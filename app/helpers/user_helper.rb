helpers do
  def current_user
    User.find_by_id session[:user_id]
  end

  def up_active?(question)
    if current_user.votes.find_or_initialize_by(votable: question).value == 1
      return "active"
    end
  end

  def down_active?(question)
    if current_user.votes.find_or_initialize_by(votable: question).value == -1
      return "active"
    end
  end

  def answer_vote_status(answer)
    @answer = answer
    if current_user
      val = current_user.votes.find_or_initialize_by(votable: answer).value
      case val
      when 1
        erb :'answers/_up'
      when -1
        erb :'answers/_down'
      else
        erb :'answers/_basic'
      end
    else
      erb :'answers/_no_user'
    end
  end
end

