package richards;

public interface Packet_interface extends dart.core.Object_interface
{
  richards.Packet_interface addTo(richards.Packet_interface queue);
  java.lang.String toString();
  richards.Packet_interface getLink();
  int getId();
  int getKind();
  int getA1();
  dart._runtime.base.DartList._int getA2();
  richards.Packet_interface setLink(richards.Packet_interface value);
  int setId(int value);
  int setKind(int value);
  int setA1(int value);
  dart._runtime.base.DartList._int setA2(dart._runtime.base.DartList._int value);
}
