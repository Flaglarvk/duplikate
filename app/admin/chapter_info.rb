# frozen_string_literal: true

# == Schema Information
#
# Table name: chapter_infos
#
#  id                  :integer          not null, primary key
#  language_name       :string
#  short_text          :text
#  source              :string
#  text                :text
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  chapter_id          :integer
#  language_id         :integer
#  resource_content_id :integer
#
# Indexes
#
#  index_chapter_infos_on_chapter_id           (chapter_id)
#  index_chapter_infos_on_language_id          (language_id)
#  index_chapter_infos_on_resource_content_id  (resource_content_id)
#
ActiveAdmin.register ChapterInfo do
  menu parent: 'Content', priority: 3
  actions :all, except: :destroy
  ActiveAdminViewHelpers.versionate(self)

  filter :chapter, as: :searchable_select,
                   ajax: { resource: Chapter }

  filter :language, as: :searchable_select,
                    ajax: { resource: Language }

  filter :text

  permit_params do
    %i[text language_name language_id source short_text resource_content_id chapter_id]
  end

  index do
    id_column

    column :language do |resource|
      link_to resource.language_name, admin_language_path(resource.language_id) if resource.language_id
    end

    column :chapter do |resource|
      link_to resource.chapter_id, admin_chapter_path(resource.chapter_id)
    end

    actions
  end

  show do
    attributes_table do
      row :id
      row :chapter do |object|
        link_to object.chapter_id, admin_chapter_path(object.chapter)
      end
      row :language
      row :resource_content do |object|
        object.get_resource_content&.name
      end

      row :text do |resource|
        div class: resource.language_name do
          resource.text.to_s.html_safe
        end
      end
      row :short_text
      row :created_at
      row :updated_at
    end

    ActiveAdminViewHelpers.diff_panel(self, resource) if params[:version]
  end

  form do |f|
    f.inputs 'Chapter Info Details' do
      f.input :chapter,
              as: :searchable_select,
              ajax: { resource: Chapter }

      f.input :language_id,
              as: :searchable_select,
              ajax: { resource: Language }

      f.input :resource_content_id,
              as: :searchable_select,
              ajax: { resource: ResourceContent }

      f.input :source
      f.input :short_text

      f.input :text, input_html: {data: {controller: 'tinymce'}}
    end
    f.actions
  end
end
