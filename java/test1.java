import foo.bar.quax;

public class test1 implements Cloneable {
	static int	static_field1;
	int			field1 = 30;
	Object		field2;
	
	quax 		bar;
	Object[]	field3;
	
	static {
		System.err.println("Loaded");
		
	}
	public static void main(String[] args) {
		long l = 1000000000000L;
	}
	
	public int calc() throws FooException {
		return 40 + 1;
	}
	
	void decodeException(FooException e) {
		
	}
}