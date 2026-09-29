import java.net.*;
import java.nio.channels.*;
import java.nio.file.*;
import java.nio.file.attribute.PosixFileAttributes;
import java.util.zip.*;

// Never run, only compiled: native-image generates the CAP cache for the native surface this
// reaches (see the Dockerfile). Reaches the JDK broadly so the cache covers what Quarkus apps use.
public class CapProbe {
  public static void main(String[] a) throws Exception {
    try (ServerSocketChannel s = ServerSocketChannel.open()) { s.bind(new InetSocketAddress("127.0.0.1", 0)); }
    try (DatagramChannel d = DatagramChannel.open()) { d.bind(null); }
    try (Selector sel = Selector.open()) { sel.selectNow(); }
    System.out.println(InetAddress.getLocalHost() + " " + NetworkInterface.networkInterfaces().count());
    Path p = Files.createTempFile("cap", ".probe");
    System.out.println(Files.readAttributes(p, PosixFileAttributes.class).permissions());
    try (WatchService w = FileSystems.getDefault().newWatchService()) { p.getParent().register(w, StandardWatchEventKinds.ENTRY_CREATE); }
    Deflater def = new Deflater(); def.setInput(new byte[16]); def.finish(); def.deflate(new byte[64]);
    System.out.println(ProcessHandle.current().pid() + " " + ProcessHandle.current().info().command().orElse(""));
    System.out.println(new ProcessBuilder("true").start().waitFor());
    System.out.println(java.util.TimeZone.getDefault().getID() + " " + java.util.Locale.getDefault());
    System.out.println(new java.util.concurrent.ForkJoinPool().submit(() -> 1).get());
  }
}
