#require_dependency MyEngine::Engine.root.join('app', 'controllers', 'my_engine', 'documents_controller').to_s
#require_dependency('/home/g1sirela/Music/vler/websocket-rails/lib/websocket_rails/base_controller.rb')

module WebsocketRails
  class BaseController
    class RandomController

      def search
        puts "dasda"
        #puts Module.nesting.inspect
        @browser = Browser.new(request.env['HTTP_USER_AGENT'], accept_language: "en-us")
        search_data_payload={"session_id" =>session.id, "user_id" => message["id"], "search_item" => message["search_item"], "browser" => @browser.name, "platform" => @browser.platform.name, "searched_at" => Time.now.utc} 
        puts search_data_payload
        publish_payload("search",search_data_payload)
      end

      def reco_click
        reco_click_data_payload={session_id=>session.id,"user_id"=>message["id"], "link"=> message["link"], "src_page"=>message["src_page"], "range"=>message["range"], "browser"=> browser.name, "platform"=> browser.platform.name, "searched_at"=> Time.now.utc}
        publish_payload('reco_click')
      end

      private

      def fetch_browser_info
        @browser = Browser.new(request.env['HTTP_USER_AGENT'], accept_language: "en-us") 
      end

      def publish_payload(queue_name,payload)
        connection = Bunny.new
        connection.start
        channel = connection.create_channel
        queue = channel.queue(queue_name)
        exchange  = channel.default_exchange
        #queue.bind(exchange) #binding isn't necessary for default exchange we can publish with routing key directly 
        exchange.publish(payload.to_json,:routing_key=>queue_name)
        connection.close 
      end
    end
  end
end
