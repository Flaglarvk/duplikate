# frozen_string_literal: true

# == Schema Information
#
# Table name: languages
#
#  id                  :integer          not null, primary key
#  direction           :string
#  es_analyzer_default :string
#  es_indexes          :string
#  iso_code            :string
#  name                :string
#  native_name         :string
#  translations_count  :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
# Indexes
#
#  index_languages_on_iso_code            (iso_code)
#  index_languages_on_translations_count  (translations_count)
#
ActiveAdmin.register Language do
  searchable_select_options(scope: Language,
                            text_attribute: :name)

  menu parent: 'Settings', priority: 1
  actions :all, except: :destroy

  ActiveAdminViewHelpers.render_translated_name_sidebar(self)

  filter :name
  filter :iso_code
  filter :direction
  filter :native_name

  permit_params do
    %i[name iso_code native_name direction es_analyzer_default]
  end

  index do
    id_column
    column :name
    column :native_name
    column :translations_count
    actions
  end

  show do
    attributes_table do
      row :id
      row :name
      row :native_name
      row :translations_count
      row :iso_code
      row :direction
      row :es_indexes
      row :es_analyzer_default
      row :created_at
      row :updated_at
    end
    active_admin_comments

    panel 'Resources for this language' do
      table do
        thead do
          td 'ID'
          td 'Type'
          td 'Name'
        end

        tbody do
          ResourceContent.where(language: resource).each do |resource_content|
            tr do
              td link_to(resource_content.id, [:admin, resource_content])
              td resource_content.sub_type
              td resource_content.name
            end
          end
        end
      end
    end
  end
end
