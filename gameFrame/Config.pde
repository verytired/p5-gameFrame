
public static class Debugger{
  public static Boolean isDebug=true;
  public static void log(String str){
    if(isDebug){
      println(str);
    }
  }
  
}
