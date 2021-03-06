require 'spec_helper'

describe 'collections/_show_document_list_row.html.erb', type: :view do
  let(:user) { stub_model(User, user_key: 'njaffer') }

  let(:work) do
    GenericWork.create(id: "123abc", creator: ["ggm"], title: ['One Hundred Years of Solitude']) do |gw|
      gw.apply_depositor_metadata(user)
    end
  end

  let(:collection) { mock_model(Collection, title: 'My awesome collection', members: [work]) }

  let(:blacklight_configuration_context) do
    Blacklight::Configuration::Context.new(controller)
  end

  context 'when not logged in' do
    before do
      allow(view).to receive(:blacklight_config).and_return(Blacklight::Configuration.new)
      allow(view).to receive(:blacklight_configuration_context).and_return(blacklight_configuration_context)
      allow(view).to receive(:current_user).and_return(nil)
      allow(work).to receive(:title_or_label).and_return("One Hundred Years of Solitude")
      allow(work).to receive(:edit_people).and_return([])
      allow(view).to receive(:render_collection_links).and_return("collections: #{collection.title}")
    end

    it "renders collections links" do
      render(partial: 'collections/show_document_list_row.html.erb', locals: { document: work })
      expect(rendered).to have_content 'My awesome collection'
    end

    it "renders works" do
      render(partial: 'collections/show_document_list_row.html.erb', locals: { document: work })
      expect(rendered).to have_content 'One Hundred Years of Solitude'
    end
  end
end
