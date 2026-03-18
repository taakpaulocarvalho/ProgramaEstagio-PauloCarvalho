public Set<Integer> setIntersection(Set<Integer> set1, Set<Integer> set2) {
   
   Set<Integer> intersectionSet = new Set<Integer>(set1);

   intersectionSet.retainAll(set2);

   return intersectionSet;
}