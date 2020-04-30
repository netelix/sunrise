class NamesController < ApplicationController
  helper_method :nameable
  before_action :check_authorization

  include Sunrise::Controllers::ModalForm

  protected

  def mutation_form_class
    Forms::EditNames
  end

  def initialize_values
    { nameable: nameable }
  end

  def resource
    :name
  end

  private

  def check_authorization
    render 'shared/access_denied' if cannot? :edit, nameable
  end

  def nameable
    @nameable ||=
      Name.new(
        nameable_type: params[:nameable_type], nameable_id: params[:nameable_id]
      )
        .nameable
  end
end
