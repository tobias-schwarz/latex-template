public class HelloWorld {
  public static void main(String[] args) {
    if(args.length == 0) {
      System.out.println("Hallo Sie!");
    } else {
      System.out.println("Hallo " + args[0] + "!");
    } 
  }
}
