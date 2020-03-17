puts 'seeds already loaded'; return if Question.any? || Answer.any?

question1 = Question.create!(title: 'Первый вопрос', body: 'Как открыть гугл?')
question2 = Question.create!(title: 'Второй вопрос', body: 'Как скачать питон?')
question3 = Question.create!(title: 'Третий вопрос', body: 'Не устанавливается ruby')

Answer.create!(body: 'Ответ', question: question1)
Answer.create!(body: 'Ответ', question: question1)
Answer.create!(body: 'Ответ', question: question1)

Answer.create!(body: 'Ответ', question: question2)
Answer.create!(body: 'Ответ', question: question2)
Answer.create!(body: 'Ответ', question: question2)
Answer.create!(body: 'Ответ', question: question2)

Answer.create!(body: 'Ответ', question: question3)
Answer.create!(body: 'Ответ', question: question3)
Answer.create!(body: 'Ответ', question: question3)
Answer.create!(body: 'Ответ', question: question3)
