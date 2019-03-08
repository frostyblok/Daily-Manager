module Response
  def json_response(object, status = :OK)
    render json: object, status: status
  end
end
