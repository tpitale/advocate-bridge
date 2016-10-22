defmodule CounselorBridge.MessageController do
  use CounselorBridge.Web, :controller

  def create(conn, params) do
    # https://www.twilio.com/docs/api/twiml/sms/twilio_request#synchronous
    # MessageSid
    # From => lookup client, lookup/create interaction, create event; notify with event
    # Body

    IO.inspect params

    client = CounselorBridge.Client.get(params[:From])

    interaction = CounselorBridge.Interaction.open_for(client) ||
                    CounselorBridge.Interaction.create(client)

    event = CounselorBridge.Event.create(interaction, %{message_id: params[:MessageSid], content: params[:Body]})

    conn
    |> put_resp_content_type("text/xml")
    |> render("create.xml")
  end
end
