public Boolean isPassed(Boolean passedExam, Boolean passedAssignments, Boolean passedProject) {
    
    if ((passedExam && passedAssignments) || (passedExam && passedProject) 
    || (passedAssignments && passedProject)){
        return true;
    }
    return false;
}