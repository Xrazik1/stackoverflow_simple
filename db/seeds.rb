puts 'seeds already loaded'; return if Question.any? || Answer.any?

user = User.create!(email: 'kolja-savelev@mail.ru', password: '123456')

question1 = user.questions.create!(title: 'Первый вопрос', body: 'Как открыть гугл?')
question2 = user.questions.create!(title: 'Второй вопрос', body: 'Как скачать питон?')
question3 = user.questions.create!(title: 'Третий вопрос', body: 'Не устанавливается ruby')

user.answers.create!(body: 'Ответ', question: question1)
user.answers.create!(body: 'Ответ', question: question1)
user.answers.create!(body: 'Ответ', question: question1)

user.answers.create!(body: 'Ответ', question: question2)
user.answers.create!(body: 'Ответ', question: question2)
user.answers.create!(body: 'Ответ', question: question2)
user.answers.create!(body: 'Ответ', question: question2)

user.answers.create!(body: 'Ответ', question: question3)
user.answers.create!(body: 'Ответ', question: question3)
user.answers.create!(body: 'Ответ', question: question3)
user.answers.create!(body: 'Ответ', question: question3)
