import java.util.Scanner;

public class TowersOfHanoi {

	public static void moves(int n, boolean leftMove) {
			
		if (n == 0) {				// base case	
			return;
		}
		moves(n-1, !leftMove);
		if (leftMove) {
			System.out.println( n + " left ");				// write (OS), printf, writeStr
		} else {
			System.out.println( n + " right ");
		}
		moves(n-1, !leftMove);
	}
	
	public static void main(String[] args) {
		int n;
		
		Scanner myInput = new Scanner( System.in );
	    System.out.print( "Enter number of game disks: " );
	    n = myInput.nextInt();
	    myInput.close();
	
		moves(n, true);
		System.out.println("done");
	}	
}
