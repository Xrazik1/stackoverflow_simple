document.addEventListener('turbolinks:load', () => {
    let answers = document.querySelector('.answers');

    if(answers) {
        answers.addEventListener('click', (e) => {
            if (e.target.closest('.edit-answer-btn')) {
                e.preventDefault();

                let answerId = e.target.dataset.answerId;

                e.target.classList.add('hidden');
                document.querySelector("form#edit-answer-" + answerId).classList.remove('hidden')
            }
        });
    }
});