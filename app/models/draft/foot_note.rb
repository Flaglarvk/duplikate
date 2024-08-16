# == Schema Information
#
# Table name: draft_foot_notes
#
#  id                   :bigint           not null, primary key
#  current_text         :text
#  draft_text           :text
#  text_matched         :boolean
#  true                 :integer
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  draft_translation_id :integer
#  foot_note_id         :integer
#  resource_content_id  :integer
#
# Indexes
#
#  index_draft_foot_notes_on_draft_translation_id  (draft_translation_id)
#  index_draft_foot_notes_on_foot_note_id          (foot_note_id)
#  index_draft_foot_notes_on_text_matched          (text_matched)
#

class Draft::FootNote < ApplicationRecord
  belongs_to :draft_translation, class_name: 'Draft::Translation'
  belongs_to :resource_content, optional: true
  belongs_to :foot_note, optional: true
  before_save :set_current_text

  def language_name
    resource_content.try :language_name
  end

  protected
  def set_current_text
    footnote = foot_note || FootNote.find_by(id: foot_note_id)
    self.current_text ||= footnote&.text
    self.text_matched = current_text == draft_text
  end
end
