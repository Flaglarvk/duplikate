# frozen_string_literal: true

ActiveAdmin.register UserProject do
  menu parent: 'Account', priority: 1

  filter :user,
         as: :searchable_select,
         ajax: { resource: User }

  filter :approved

  permit_params do
    %i[user_id resource_content_id description admin_notes approved]
  end

  form do |f|
    f.inputs 'User project Details' do
      f.input :approved
      f.input :user_id

      f.input :description
      f.input :admin_notes

      f.input :resource_content,
              as: :searchable_select,
              ajax: { resource: ResourceContent }
    end

    f.actions
  end
end
