/*Do not change the name of the class or the method signature.*/

public class CampApexSolution {
    public Decimal calculateAverageHousesPerStreet(List<Integer> streetHouseCounts){
        System.debug('This is the incoming list contents:' + streetHouseCounts);
        Decimal result = 0;
        Integer sizeofList = streetHouseCounts.size();

        if(streetHouseCounts.size() == 0){
            return result;
        } else if (streetHouseCounts != null && streetHouseCounts.isEmpty()) {
            return result;
        } else if (sizeofList == 1) { 
            Decimal result2 = 0;
            return result2 = streetHouseCounts.get(0);
        } else if {
        
    Integer total = 0;
    Double dAvg;

    for (Integer i : streetHouseCounts) {
    total += i;
    }

dAvg = Double.valueOf(total) / streetHouseCounts.size();
System.debug('The value of dAvg is: ' + dAvg);
// if(streetHouseCounts.size() > 1) {
// return dAvg;
} else {
return result;
}
//return result;
}
}