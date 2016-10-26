class SyncOrdersController < ApplicationController
  skip_before_action :verify_authenticity_token

  @@sp_id = '601265'
  @@sp_username = 'admin@roundhut'
  @@sp_password = "Esimba!234"

  def create
    @sync_order = parse_sync_order
    @subscriber = Subscriber.where(phone_number: @sync_order.user_id, service_id: @sync_order.service_id).first

    if @subscriber.nil? then
	@subscriber = Subscriber.new
	@subscriber.phone_number = @sync_order.user_id
	@subscriber.service_id = @sync_order.service_id
	@subscriber.first_subscribed_at = DateTime.now
	@subscriber.last_subscribed_at = DateTime.now
    end 

    if @sync_order.update_description == "Addition" then
	@subscriber.active = true
	@subscriber.last_subscribed_at = DateTime.now
    elsif @sync_order.update_description == "Deletion" then
	@subscriber.active = false
	@subscriber.last_unsubscribed_at = DateTime.now
    end

    if @sync_order.save && @subscriber.save then
	send_response 'Hello world!'
	render plain: "success"
    else
	render plain: "could not save sync order object"
    end
  end

  private
  def parse_sync_order
    doc = Nokogiri::XML(request.body.read)

    sync_order = SyncOrder.new
    sync_order.user_id = doc.at_xpath("//ID").content
    sync_order.user_type = doc.at_xpath("//type").content.to_i
    sync_order.product_id = doc.at_xpath("//loc:productID").content
    sync_order.service_id = doc.at_xpath("//loc:serviceID").content
    sync_order.services_list = doc.at_xpath("//loc:serviceList").content
    sync_order.update_type = doc.at_xpath("//loc:updateType").content.to_i
    sync_order.update_time = DateTime.strptime(doc.at_xpath("//loc:updateTime").content, '%Y%m%d%H%M%S')
    sync_order.update_description = doc.at_xpath("//loc:updateDesc").content
    sync_order.effective_time = DateTime.strptime(doc.at_xpath("//loc:effectiveTime").content, '%Y%m%d%H%M%S')
    sync_order.expiry_time = DateTime.strptime(doc.at_xpath("//loc:expiryTime").content, '%Y%m%d%H%M')
    sync_order.transaction_id = doc.xpath("//value").first.content
    sync_order.order_key = doc.xpath("//value")[1].content
    sync_order.mdspsubexpmode = doc.xpath("//value")[2].content.to_i
    sync_order.object_type = doc.xpath("//value")[3].content.to_i
    sync_order.traceunique_id = doc.xpath("//value")[4].content
    sync_order.rent_success = doc.xpath("//value")[5].content == "true"

    sync_order
  end

  def build_response(message_text, timestamp_string) 
    namespaces = {
	 "xmlns:soapenv" => "http://schemas.xmlsoap.org/soap/envelope/",
	 "xmlns:v2" => "http://www.huawei.com.cn/schema/common/v2_1",
	 "xmlns:loc" => "http://www.csapi.org/schema/parlayx/sms/send/v2_2/local"
    }

    builder = Nokogiri::XML::Builder.new { |xml|
	 xml['soapenv'].Envelope(namespaces) do
	    xml['soapenv'].Header do
	      xml['v2'].RequestSOAPHeader do
	       xml['v2'].spId(@@sp_id)
	       xml['v2'].spPassword(Digest::MD5.hexdigest(@@sp_id + @@sp_password + timestamp_string))
	       xml['v2'].serviceId(@service_id)
	       xml['v2'].timeStamp(timestamp_string)
	      end # end of RequestSOAPHeader
	    end # end of Header

	    xml['soapenv'].Body do
	       xml['loc'].sendSms do
		    xml['loc'].addressses('tel: #{@subscriber.phone_number}')
		    xml['loc'].senderName('321')
		    xml['loc'].message(message_text)
#xml['loc'].receiptRequest do
#			xml.endpoint("http://hostIPaddress:port/action")
#			xml.interfaceName("SmsNotification")
#			xml.correlator(DateTime.now.strftime("%s"))
#		    end
	       end # end of sendSms 
	    end # end of Body
	end # end of Envelope
    }

    builder.to_xml
  end

  def send_response(response)
    timestamp_string = DateTime.now.strftime("%Y%m%d%H%M%S")
    uri = URI('http://41.90.0.132:8310/SendSmsService/services/SendSms/')
    send_request = Net::HTTP::Post.new uri
    send_request.basic_auth @@sp_username, Digest::MD5.hexdigest(@@sp_id + @@sp_password + timestamp_string)
    send_request.body = build_response(response, timestamp_string)
    send_request.content_type = 'text/xml'
    send_response = Net::HTTP.new(uri.host, uri.port).start  do |http|
	http.request send_request
    end	

    logger.info "SendSMSRequest Response: #{send_response.body}"
#    logger.info "SendSMSRequest Response: insert response here"
  end
end
