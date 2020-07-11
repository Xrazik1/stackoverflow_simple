document.addEventListener('turbolinks:load', () => {
    document.querySelector('.question').addEventListener('click', (e) => {
        if (e.target.closest('.edit-question-btn')) {
            e.preventDefault();

            let questionId = e.target.dataset.questionId;

            e.target.classList.add('hidden');
            document.querySelector("form#edit-question-" + questionId).classList.remove('hidden')
        }
    })
});