get '/questions' do
  @questions = Question.all
  erb :index
end

post '/questions' do
  params['question']['user'] = current_user
  Question.create(params[:question])
  redirect to '/questions'
end

get '/questions/new' do
  if current_user
    erb :'questions/new'
  else
    redirect '/login'
  end
end

get '/questions/:id' do
  @question = Question.find_by_id(params[:id])
  @answers = @question.answers.order(favorite: :desc)
  erb :'/questions/show'
end


# submit answer
post '/questions/:question_id/answers' do
  if !current_user
    redirect '/login'
  end
  q_id = params[:question_id]
  Answer.create(content: params[:answer], user_id: session[:user_id], question_id: q_id )

  redirect "/questions/#{q_id}"
end


post '/questions/:id/votes/up' do
  question = Question.find_by_id params[:id]
  if current_user
    val = 1
    vote = question.votes.find_by(user: current_user)
    if vote
      vote.value == val ? vote.value = 0 : vote.value = val
      vote.save
    else
      vote = Vote.create(value: val, user: current_user, votable: question)
    end
    total = question.points
    value = vote.value
    { value: value, total: total }.to_json
  end
end

post '/questions/:id/votes/down' do
  question = Question.find_by_id params[:id]
  if current_user
    val = -1
    vote = question.votes.find_by(user: current_user)
    if vote
      vote.value == val ? vote.value = 0 : vote.value = val
      vote.save
    else
      vote = Vote.create(value: val, user: current_user, votable: question)
    end
    total = question.points
    value = vote.value
    { value: value, total: total }.to_json
  end
end





