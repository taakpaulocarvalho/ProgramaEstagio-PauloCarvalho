trigger TarefaTrigger on Task (before insert) {

    List<Id> tasks = new List<Id>();

    for (Task task : Trigger.new) {
        
        if (task != null && task.WhatId != null){
            tasks.add(task.WhatId);
        }
    }

    for (Task task : Trigger.new){

        if (task.IsClosed == false && tasks.contains(task.WhatId)){
            task.addError('Já existe uma tarefa em aberto nesse caso. Encerre-a antes de abrir uma nova!');
        }
    }
}