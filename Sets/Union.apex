public Set<Integer> setUnion(Set<Integer> set1, Set<Integer> set2) {
    
    Set<Integer> unionSet = new Set<Integer>();

    if (set1 != null)
        unionSet.addAll(set1);

    if (set2 != null)
        unionSet.addAll(set2);

    return unionSet;
}