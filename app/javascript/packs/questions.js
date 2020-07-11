document.addEventListener('turbolinks:load', () => {
    let question = document.querySelector('.question')

    if(question){
        question.addEventListener('click', (e) => {
            if (e.target.closest('.edit-question-btn')) {
                e.preventDefault();

                let questionId = e.target.dataset.questionId;

                e.target.classList.add('hidden');
                document.querySelector("form#edit-question-" + questionId).classList.remove('hidden')
            }
        })
    }
});