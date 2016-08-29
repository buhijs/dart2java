package havlak;

public class UnionFindNode extends dart._runtime.base.DartObject implements havlak.UnionFindNode_interface
{
    public static dart._runtime.types.simple.InterfaceTypeInfo dart2java$typeInfo = new dart._runtime.types.simple.InterfaceTypeInfo("havlak.UnionFindNode");
    static {
      havlak.UnionFindNode.dart2java$typeInfo.superclass = new dart._runtime.types.simple.InterfaceTypeExpr(dart._runtime.helpers.ObjectHelper.dart2java$typeInfo);
    }
    public int dfsNumber;
    public havlak.UnionFindNode_interface parent;
    public havlak.BasicBlock_interface bb;
    public havlak.SimpleLoop_interface loop;
  
    public UnionFindNode(dart._runtime.types.simple.Type type)
    {
      super((dart._runtime.helpers.ConstructorHelper.EmptyConstructorMarker) null, type);
      this._constructor();
    }
    public UnionFindNode(dart._runtime.helpers.ConstructorHelper.EmptyConstructorMarker arg, dart._runtime.types.simple.Type type)
    {
      super(arg, type);
    }
  
    protected void _constructor()
    {
      final dart._runtime.types.simple.TypeEnvironment dart2java$localTypeEnv = this.dart2java$type.env;
      this.dfsNumber = 0;
      super._constructor();
    }
    public void initNode(havlak.BasicBlock_interface bb, int dfsNumber)
    {
      final dart._runtime.types.simple.TypeEnvironment dart2java$localTypeEnv = this.dart2java$type.env;
      this.setParent(this);
      this.setBb(bb);
      this.setDfsNumber(dfsNumber);
    }
    public havlak.UnionFindNode_interface findSet()
    {
      final dart._runtime.types.simple.TypeEnvironment dart2java$localTypeEnv = this.dart2java$type.env;
      dart._runtime.base.DartList<havlak.UnionFindNode_interface> nodeList = (dart._runtime.base.DartList) dart._runtime.base.DartList.Generic._fromArguments(havlak.UnionFindNode_interface.class);
      havlak.UnionFindNode_interface node = this;
      while ((!dart._runtime.helpers.ObjectHelper.operatorEqual(node, node.getParent())))
      {
        if ((!dart._runtime.helpers.ObjectHelper.operatorEqual(node.getParent(), node.getParent().getParent())))
        {
          nodeList.add(node);
        }
        node = node.getParent();
      }
      for (int iter = 0; (iter < nodeList.getLength()); iter = (iter + 1))
      {
        nodeList.operatorAt(iter).setParent(node.getParent());
      }
      return node;
    }
    public void union(havlak.UnionFindNode_interface unionFindNode)
    {
      final dart._runtime.types.simple.TypeEnvironment dart2java$localTypeEnv = this.dart2java$type.env;
      this.setParent(unionFindNode);
    }
    public havlak.SimpleLoop_interface setLoop_(havlak.SimpleLoop_interface l)
    {
      final dart._runtime.types.simple.TypeEnvironment dart2java$localTypeEnv = this.dart2java$type.env;
      return this.setLoop(l);
    }
    public int getDfsNumber()
    {
      return this.dfsNumber;
    }
    public havlak.UnionFindNode_interface getParent()
    {
      return this.parent;
    }
    public havlak.BasicBlock_interface getBb()
    {
      return this.bb;
    }
    public havlak.SimpleLoop_interface getLoop()
    {
      return this.loop;
    }
    public int setDfsNumber(int value)
    {
      this.dfsNumber = value;
      return value;
    }
    public havlak.UnionFindNode_interface setParent(havlak.UnionFindNode_interface value)
    {
      this.parent = value;
      return value;
    }
    public havlak.BasicBlock_interface setBb(havlak.BasicBlock_interface value)
    {
      this.bb = value;
      return value;
    }
    public havlak.SimpleLoop_interface setLoop(havlak.SimpleLoop_interface value)
    {
      this.loop = value;
      return value;
    }
}
