public class arrays {
	static Object[] simple = new Object[1];
	static int[][] dual = new int[10][20];
	
	public static void main(String[] args) {
		System.out.println(simple.getClass().getName());
		System.out.println(dual.getClass().getName());
	}
}