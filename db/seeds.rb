# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

question1 = Question.create(title: 'Первый вопрос', body: 'Как открыть гугл?')
question2 = Question.create(title: 'Второй вопрос', body: 'Как скачать питон?')
question3 = Question.create(title: 'Третий вопрос', body: 'Не устанавливается ruby')

Answer.create(body: 'Ответ', question_id: question1.id)
Answer.create(body: 'Ответ', question_id: question1.id)
Answer.create(body: 'Ответ', question_id: question1.id)

Answer.create(body: 'Ответ', question_id: question2.id)
Answer.create(body: 'Ответ', question_id: question2.id)
Answer.create(body: 'Ответ', question_id: question2.id)
Answer.create(body: 'Ответ', question_id: question2.id)

Answer.create(body: 'Ответ', question_id: question3.id)
Answer.create(body: 'Ответ', question_id: question3.id)
Answer.create(body: 'Ответ', question_id: question3.id)
Answer.create(body: 'Ответ', question_id: question3.id)
