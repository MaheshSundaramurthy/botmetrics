RSpec.describe EventSerializer::Kik do
  let!(:timestamp)    { Time.now.to_i * 1000 }
  let(:data) {
    [
      {
        "chatId": "b3be3bc15dbe59931666c06290abd944aaa769bb2ecaaf859bfb65678880afab",
        "type": "text",
        "from": "laura",
        "participants": ["laura"],
        "id": "6d8d060c-3ae4-46fc-bb18-6e7ba3182c0f",
        "timestamp": timestamp,
        "body": "Hi!",
        "mention": nil
      }
    ]
  }

  describe '.new' do
    context 'invalid params' do
      it { expect { EventSerializer::Kik.new(nil, 'bi_uid') }.to raise_error('Supplied Option Is Nil') }
    end

    context 'invalid data' do
      it { expect { EventSerializer::Kik.new({ data: data }, 'bi_uid') }.to raise_error('Invalid Data Supplied') }
    end
  end

  describe '#serialize' do
    subject { EventSerializer.new(:kik, data, 'bi_uid').serialize }

    let(:serialized) {
      [{
        data:  {
          event_type: 'message',
          is_for_bot: true,
          is_from_bot: false,
          is_im: false,
          text: "Hi!",
          provider: "kik",
          created_at: Time.at(timestamp.to_f / 1000),
          event_attributes: {
            chat_id: "b3be3bc15dbe59931666c06290abd944aaa769bb2ecaaf859bfb65678880afab",
            id: "6d8d060c-3ae4-46fc-bb18-6e7ba3182c0f",
            sub_type: "text",
            from: "laura",
            participants: ["laura"]
          }},
        recip_info: {
          from: "laura", to: nil
        }
      }]
    }


    it { expect(subject).to eql serialized }
  end
end
