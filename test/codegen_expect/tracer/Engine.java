package tracer;

public class Engine extends dart._runtime.base.DartObject
{
    public static dart._runtime.types.simple.InterfaceTypeInfo dart2java$typeInfo = new dart._runtime.types.simple.InterfaceTypeInfo("file:///usr/local/google/home/springerm/ddc-java/gen/codegen_tests/tracer.dart", "Engine");
    static {
      tracer.Engine.dart2java$typeInfo.superclass = new dart._runtime.types.simple.InterfaceTypeExpr(dart._runtime.helpers.ObjectHelper.dart2java$typeInfo);
    }
    public int canvasWidth;
    public int canvasHeight;
    public int pixelWidth;
    public int pixelHeight;
    public java.lang.Boolean renderDiffuse;
    public java.lang.Boolean renderShadows;
    public java.lang.Boolean renderHighlights;
    public java.lang.Boolean renderReflections;
    public int rayDepth;
    public java.lang.Object canvas;
  
    public Engine(int canvasWidth, int canvasHeight, int pixelWidth, int pixelHeight, java.lang.Boolean renderDiffuse, java.lang.Boolean renderShadows, java.lang.Boolean renderHighlights, java.lang.Boolean renderReflections, int rayDepth)
    {
      super((dart._runtime.helpers.ConstructorHelper.EmptyConstructorMarker) null);
      this._constructor(canvasWidth, canvasHeight, pixelWidth, pixelHeight, renderDiffuse, renderShadows, renderHighlights, renderReflections, rayDepth);
    }
    public Engine(dart._runtime.helpers.ConstructorHelper.EmptyConstructorMarker arg)
    {
      super(arg);
    }
  
    protected void _constructor(int canvasWidth, int canvasHeight, int pixelWidth, int pixelHeight, java.lang.Boolean renderDiffuse, java.lang.Boolean renderShadows, java.lang.Boolean renderHighlights, java.lang.Boolean renderReflections, int rayDepth)
    {
      this.canvasWidth = 0;
      this.canvasHeight = 0;
      this.pixelWidth = 0;
      this.pixelHeight = 0;
      this.rayDepth = 0;
      this.canvasWidth = canvasWidth;
      this.canvasHeight = canvasHeight;
      this.pixelWidth = pixelWidth;
      this.pixelHeight = pixelHeight;
      this.renderDiffuse = renderDiffuse;
      this.renderShadows = renderShadows;
      this.renderHighlights = renderHighlights;
      this.renderReflections = renderReflections;
      this.rayDepth = rayDepth;
      super._constructor();
      this.setCanvasHeight(dart._runtime.helpers.IntegerHelper.operatorTruncatedDivide(this.getCanvasHeight(), this.getPixelHeight()));
      this.setCanvasWidth(dart._runtime.helpers.IntegerHelper.operatorTruncatedDivide(this.getCanvasWidth(), this.getPixelWidth()));
    }
    public void setPixel(int x, int y, tracer.Color color)
    {
      java.lang.Object pxW = null;
      java.lang.Object pxH = null;
      pxW = this.getPixelWidth();
      pxH = this.getPixelHeight();
      if ((!dart._runtime.helpers.ObjectHelper.operatorEqual(this.getCanvas(), null)))
      {
        dart._runtime.helpers.DynamicHelper.invoke("setFillStyle", this.getCanvas(), dart._runtime.helpers.ObjectHelper.toString(color));
        dart._runtime.helpers.DynamicHelper.invoke("fillRect", this.getCanvas(), dart._runtime.helpers.IntegerHelper.operatorStar(x, (java.lang.Number) pxW), dart._runtime.helpers.IntegerHelper.operatorStar(y, (java.lang.Number) pxH), pxW, pxH);
      }
      else
      {
        tracer.__TopLevel.checkNumber = dart._runtime.helpers.DynamicHelper.invoke("operatorPlus", tracer.__TopLevel.checkNumber, color.brightness());
      }
    }
    public void renderScene(tracer.Scene scene, java.lang.Object canvas)
    {
      tracer.__TopLevel.checkNumber = 0;
      this.setCanvas((dart._runtime.helpers.ObjectHelper.operatorEqual(canvas, null)) ? (null) : (dart._runtime.helpers.DynamicHelper.invoke("getContext", canvas, "2d")));
      int canvasHeight = this.getCanvasHeight();
      int canvasWidth = this.getCanvasWidth();
      for (int y = 0; dart._runtime.helpers.IntegerHelper.operatorLess(y, canvasHeight); y = dart._runtime.helpers.IntegerHelper.operatorPlus(y, 1))
      {
        for (int x = 0; dart._runtime.helpers.IntegerHelper.operatorLess(x, canvasWidth); x = dart._runtime.helpers.IntegerHelper.operatorPlus(x, 1))
        {
          java.lang.Double yp = dart._runtime.helpers.DoubleHelper.operatorMinus(dart._runtime.helpers.DoubleHelper.operatorStar(dart._runtime.helpers.IntegerHelper.operatorDivide(y, canvasHeight), 2), 1);
          java.lang.Double xp = dart._runtime.helpers.DoubleHelper.operatorMinus(dart._runtime.helpers.DoubleHelper.operatorStar(dart._runtime.helpers.IntegerHelper.operatorDivide(x, canvasWidth), 2), 1);
          java.lang.Object ray = dart._runtime.helpers.DynamicHelper.invoke("getRay", scene.getCamera(), xp, yp);
          this.setPixel(x, y, this.getPixelColor((tracer.Ray) ray, scene));
        }
      }
      if ((dart._runtime.helpers.ObjectHelper.operatorEqual(canvas, null) && (!dart._runtime.helpers.ObjectHelper.operatorEqual(tracer.__TopLevel.checkNumber, 55545))))
      {
        throw new RuntimeException("Scene rendered incorrectly");
      }
    }
    public tracer.Color getPixelColor(tracer.Ray ray, tracer.Scene scene)
    {
      tracer.IntersectionInfo info = this.testIntersection(ray, scene, null);
      if (info.getIsHit())
      {
        tracer.Color color = this.rayTrace(info, ray, scene, 0);
        return color;
      }
      return (tracer.Color) dart._runtime.helpers.DynamicHelper.invoke("getColor", scene.getBackground());
    }
    public tracer.IntersectionInfo testIntersection(tracer.Ray ray, tracer.Scene scene, tracer.BaseShape exclude)
    {
      int hits = 0;
      tracer.IntersectionInfo best = new tracer.IntersectionInfo();
      best.setDistance(2000.0);
      for (int i = 0; dart._runtime.helpers.IntegerHelper.operatorLess(i, (java.lang.Number) dart._runtime.helpers.DynamicHelper.invoke("getLength", scene.getShapes())); i = dart._runtime.helpers.IntegerHelper.operatorPlus(i, 1))
      {
        java.lang.Object shape = dart._runtime.helpers.DynamicHelper.invoke("operatorAt", scene.getShapes(), i);
        if ((!dart._runtime.helpers.ObjectHelper.operatorEqual(shape, exclude)))
        {
          tracer.IntersectionInfo info = (tracer.IntersectionInfo) dart._runtime.helpers.DynamicHelper.invoke("intersect", shape, ray);
          if ((((java.lang.Boolean) info.getIsHit() && (java.lang.Boolean) dart._runtime.helpers.DynamicHelper.invoke("operatorGreaterEqual", info.getDistance(), 0)) && (java.lang.Boolean) dart._runtime.helpers.DynamicHelper.invoke("operatorLess", info.getDistance(), best.getDistance())))
          {
            best = info;
            hits = dart._runtime.helpers.IntegerHelper.operatorPlus(hits, 1);
          }
        }
      }
      best.setHitCount(hits);
      return best;
    }
    public tracer.Ray getReflectionRay(tracer.Vector P, tracer.Vector N, tracer.Vector V)
    {
      java.lang.Double c1 = dart._runtime.helpers.DoubleHelper.operatorUnaryMinus(N.dot(V));
      tracer.Vector R1 = N.multiplyScalar(dart._runtime.helpers.IntegerHelper.operatorStar(2, c1)).operatorPlus(V);
      return new tracer.Ray(P, R1);
    }
    public tracer.Color rayTrace(tracer.IntersectionInfo info, tracer.Ray ray, tracer.Scene scene, int depth)
    {
      tracer.Color color = (tracer.Color) dart._runtime.helpers.DynamicHelper.invoke("multiplyScalar", info.getColor(), dart._runtime.helpers.DynamicHelper.invoke("getAmbience", scene.getBackground()));
      tracer.Color oldColor = color;
      java.lang.Number shininess = dart.math.__TopLevel.pow(10.0, (java.lang.Number) dart._runtime.helpers.DynamicHelper.invoke("operatorPlus", dart._runtime.helpers.DynamicHelper.invoke("getGloss", dart._runtime.helpers.DynamicHelper.invoke("getMaterial", info.getShape())), 1.0));
      for (int i = 0; dart._runtime.helpers.IntegerHelper.operatorLess(i, (java.lang.Number) dart._runtime.helpers.DynamicHelper.invoke("getLength", scene.getLights())); i = dart._runtime.helpers.IntegerHelper.operatorPlus(i, 1))
      {
        java.lang.Object light = dart._runtime.helpers.DynamicHelper.invoke("operatorAt", scene.getLights(), i);
        java.lang.Object v = dart._runtime.helpers.DynamicHelper.invoke("normalize", dart._runtime.helpers.DynamicHelper.invoke("operatorMinus", dart._runtime.helpers.DynamicHelper.invoke("getPosition", light), info.getPosition()));
        if (this.getRenderDiffuse())
        {
          java.lang.Object L = dart._runtime.helpers.DynamicHelper.invoke("dot", v, info.getNormal());
          if ((java.lang.Boolean) dart._runtime.helpers.DynamicHelper.invoke("operatorGreater", L, 0.0))
          {
            color = color.operatorPlus((tracer.Color) dart._runtime.helpers.DynamicHelper.invoke("operatorStar", info.getColor(), dart._runtime.helpers.DynamicHelper.invoke("multiplyScalar", dart._runtime.helpers.DynamicHelper.invoke("getColor", light), L)));
          }
        }
        if (dart._runtime.helpers.IntegerHelper.operatorLessEqual(depth, this.getRayDepth()))
        {
          if (((java.lang.Boolean) this.getRenderReflections() && (java.lang.Boolean) dart._runtime.helpers.DynamicHelper.invoke("operatorGreater", dart._runtime.helpers.DynamicHelper.invoke("getReflection", dart._runtime.helpers.DynamicHelper.invoke("getMaterial", info.getShape())), 0.0)))
          {
            tracer.Ray reflectionRay = this.getReflectionRay((tracer.Vector) info.getPosition(), (tracer.Vector) info.getNormal(), (tracer.Vector) ray.getDirection());
            tracer.IntersectionInfo refl = this.testIntersection(reflectionRay, scene, (tracer.BaseShape) info.getShape());
            if (((java.lang.Boolean) refl.getIsHit() && (java.lang.Boolean) dart._runtime.helpers.DynamicHelper.invoke("operatorGreater", refl.getDistance(), 0.0)))
            {
              refl.setColor(this.rayTrace(refl, reflectionRay, scene, dart._runtime.helpers.IntegerHelper.operatorPlus(depth, 1)));
            }
            else
            {
              refl.setColor(dart._runtime.helpers.DynamicHelper.invoke("getColor", scene.getBackground()));
            }
            color = color.blend((tracer.Color) refl.getColor(), (java.lang.Double) dart._runtime.helpers.DynamicHelper.invoke("getReflection", dart._runtime.helpers.DynamicHelper.invoke("getMaterial", info.getShape())));
          }
        }
        tracer.IntersectionInfo shadowInfo = new tracer.IntersectionInfo();
        if (this.getRenderShadows())
        {
          tracer.Ray shadowRay = new tracer.Ray(info.getPosition(), v);
          shadowInfo = this.testIntersection(shadowRay, scene, (tracer.BaseShape) info.getShape());
          if ((shadowInfo.getIsHit() && (!dart._runtime.helpers.ObjectHelper.operatorEqual(shadowInfo.getShape(), info.getShape()))))
          {
            tracer.Color vA = color.multiplyScalar(0.5);
            java.lang.Double dB = (java.lang.Double) dart._runtime.helpers.DoubleHelper.operatorStar(0.5, dart.math.__TopLevel.pow((java.lang.Number) dart._runtime.helpers.DynamicHelper.invoke("getTransparency", dart._runtime.helpers.DynamicHelper.invoke("getMaterial", shadowInfo.getShape())), 0.5));
            color = vA.addScalar(dB);
          }
        }
        if ((((java.lang.Boolean) this.getRenderHighlights() && (!(java.lang.Boolean) shadowInfo.getIsHit())) && (java.lang.Boolean) dart._runtime.helpers.DynamicHelper.invoke("operatorGreater", dart._runtime.helpers.DynamicHelper.invoke("getGloss", dart._runtime.helpers.DynamicHelper.invoke("getMaterial", info.getShape())), 0.0)))
        {
          java.lang.Object Lv = dart._runtime.helpers.DynamicHelper.invoke("normalize", dart._runtime.helpers.DynamicHelper.invoke("operatorMinus", dart._runtime.helpers.DynamicHelper.invoke("getPosition", info.getShape()), dart._runtime.helpers.DynamicHelper.invoke("getPosition", light)));
          java.lang.Object E = dart._runtime.helpers.DynamicHelper.invoke("normalize", dart._runtime.helpers.DynamicHelper.invoke("operatorMinus", dart._runtime.helpers.DynamicHelper.invoke("getPosition", scene.getCamera()), dart._runtime.helpers.DynamicHelper.invoke("getPosition", info.getShape())));
          java.lang.Object H = dart._runtime.helpers.DynamicHelper.invoke("normalize", dart._runtime.helpers.DynamicHelper.invoke("operatorMinus", E, Lv));
          java.lang.Number glossWeight = dart.math.__TopLevel.pow(dart.math.__TopLevel.max((java.lang.Number) dart._runtime.helpers.DynamicHelper.invoke("dot", info.getNormal(), H), 0.0), shininess);
          color = (tracer.Color) dart._runtime.helpers.DynamicHelper.invoke("operatorPlus", dart._runtime.helpers.DynamicHelper.invoke("multiplyScalar", dart._runtime.helpers.DynamicHelper.invoke("getColor", light), glossWeight), color);
        }
      }
      return color.limit();
    }
    public java.lang.String toString()
    {
      return (((("Engine [canvasWidth: " + this.getCanvasWidth()) + ", canvasHeight: ") + this.getCanvasHeight()) + "]");
    }
    public int getCanvasWidth()
    {
      return this.canvasWidth;
    }
    public int getCanvasHeight()
    {
      return this.canvasHeight;
    }
    public int getPixelWidth()
    {
      return this.pixelWidth;
    }
    public int getPixelHeight()
    {
      return this.pixelHeight;
    }
    public java.lang.Boolean getRenderDiffuse()
    {
      return this.renderDiffuse;
    }
    public java.lang.Boolean getRenderShadows()
    {
      return this.renderShadows;
    }
    public java.lang.Boolean getRenderHighlights()
    {
      return this.renderHighlights;
    }
    public java.lang.Boolean getRenderReflections()
    {
      return this.renderReflections;
    }
    public int getRayDepth()
    {
      return this.rayDepth;
    }
    public java.lang.Object getCanvas()
    {
      return this.canvas;
    }
    public int setCanvasWidth(int value)
    {
      this.canvasWidth = value;
      return value;
    }
    public int setCanvasHeight(int value)
    {
      this.canvasHeight = value;
      return value;
    }
    public int setPixelWidth(int value)
    {
      this.pixelWidth = value;
      return value;
    }
    public int setPixelHeight(int value)
    {
      this.pixelHeight = value;
      return value;
    }
    public java.lang.Boolean setRenderDiffuse(java.lang.Boolean value)
    {
      this.renderDiffuse = value;
      return value;
    }
    public java.lang.Boolean setRenderShadows(java.lang.Boolean value)
    {
      this.renderShadows = value;
      return value;
    }
    public java.lang.Boolean setRenderHighlights(java.lang.Boolean value)
    {
      this.renderHighlights = value;
      return value;
    }
    public java.lang.Boolean setRenderReflections(java.lang.Boolean value)
    {
      this.renderReflections = value;
      return value;
    }
    public int setRayDepth(int value)
    {
      this.rayDepth = value;
      return value;
    }
    public java.lang.Object setCanvas(java.lang.Object value)
    {
      this.canvas = value;
      return value;
    }
}
