within ;
model new_r
  Modelica.Electrical.Analog.Sources.ConstantVoltage constantVoltage(V=85)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-172,10})));
  Modelica.Electrical.PowerConverters.DCDC.ChopperStepUp boost annotation (
    Placement(visible = true, transformation(origin={-78,6},     extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Basic.Inductor inductor(L=0.002)   annotation (
    Placement(visible = true, transformation(origin={-150,44},    extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Basic.Ground ground annotation (
    Placement(visible = true, transformation(origin={-172,-46},    extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.PowerConverters.DCDC.Control.SignalPWM pwm(
    constantDutyCycle=0.2,
    f=10000,
    startTime=0,
    useConstantDutyCycle=false)                                                                                                                   annotation (
    Placement(visible = true, transformation(origin={-78,-64},    extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Sensors.CurrentSensor currentSensor annotation (
    Placement(visible = true, transformation(origin={-114,44},    extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Basic.Capacitor capacitor(C=0.0015, v(start=170))      annotation (
    Placement(visible = true, transformation(origin={-28,2},     extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Electrical.Analog.Sensors.VoltageSensor voltageSensor annotation (
    Placement(visible = true, transformation(origin={4,2},      extent = {{-10, 10}, {10, -10}}, rotation = -90)));
  Modelica.Electrical.Analog.Sensors.CurrentSensor currentSensor1 annotation (
    Placement(visible = true, transformation(origin={2,62},    extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput d annotation (
    Placement(visible = true, transformation(origin={-148,-64},    extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin={-148,-64},    extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput i_l annotation (
    Placement(visible = true, transformation(origin={-114,12},   extent = {{-10, -10}, {10, 10}}, rotation=-90), iconTransformation(origin={-102,38},   extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput v_o annotation (
    Placement(visible = true, transformation(origin={38,2},     extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin={38,2},     extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput i_o annotation (
    Placement(visible = true, transformation(origin={26,44},    extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin={26,44},    extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Basic.Resistor R1(R=500)    annotation (
    Placement(visible = true, transformation(origin={132,46},   extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Electrical.Analog.Basic.Resistor R2(R=500)    annotation (
    Placement(visible = true, transformation(origin={132,10},   extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Sources.BooleanStep booleanStep(startTime=0.3)   annotation (
    Placement(visible = true, transformation(origin={172,-24},   extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Ideal.IdealClosingSwitch switch annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={174,10})));
  Modelica.Electrical.Analog.Basic.Resistor R3(R=500)    annotation (
    Placement(visible = true, transformation(origin={98,48},    extent={{-10,-10},
            {10,10}},                                                                            rotation=180)));
  Modelica.Electrical.Analog.Ideal.IdealOpeningSwitch switch1
    annotation (Placement(transformation(extent={{88,52},{108,72}})));
  Modelica.Blocks.Sources.BooleanStep booleanStep1(startTime=0.7)  annotation (
    Placement(visible = true, transformation(origin={66,88},     extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const(k=0.34)
    annotation (Placement(transformation(extent={{-136,-46},{-116,-26}})));
equation
  connect(constantVoltage.p,inductor. p) annotation (
    Line(points={{-172,20},{-172,44},{-160,44}},        color = {0, 0, 255}));
  connect(constantVoltage.n,ground. p) annotation (
    Line(points={{-172,0},{-172,-36}},                                color = {0, 0, 255}));
  connect(constantVoltage.n,boost. dc_n1) annotation (
    Line(points={{-172,0},{-88,0}},        color = {0, 0, 255}));
  connect(pwm.fire,boost. fire_p) annotation (
    Line(points={{-84,-53},{-84,-6}},      color = {255, 0, 255}));
  connect(boost.dc_p2,capacitor. p) annotation (
    Line(points={{-68,12},{-28,12}},                            color = {0, 0, 255}));
  connect(boost.dc_n2,capacitor. n) annotation (
    Line(points={{-68,0},{-52,0},{-52,-8},{-28,-8}},                    color = {0, 0, 255}));
  connect(capacitor.p,voltageSensor. p) annotation (
    Line(points={{-28,12},{4,12}},                           color = {0, 0, 255}));
  connect(capacitor.n,voltageSensor. n) annotation (
    Line(points={{-28,-8},{4,-8}},     color = {0, 0, 255}));
  connect(voltageSensor.v,v_o)  annotation (
    Line(points={{15,2},{38,2}},                            color = {0, 0, 127}));
  connect(capacitor.p,currentSensor1. p) annotation (
    Line(points={{-28,12},{-28,62},{-8,62}},        color = {0, 0, 255}));
  connect(currentSensor1.i,i_o)  annotation (
    Line(points={{2,51},{2,44},{26,44}},                           color = {0, 0, 127}));
  connect(inductor.n,currentSensor. p)
    annotation (Line(points={{-140,44},{-124,44}}, color={0,0,255}));
  connect(currentSensor.n,boost. dc_p1) annotation (Line(points={{-104,44},{-96,
          44},{-96,12},{-88,12}}, color={0,0,255}));
  connect(i_l,i_l)
    annotation (Line(points={{-114,12},{-114,12}}, color={0,0,127}));
  connect(currentSensor.i,i_l)
    annotation (Line(points={{-114,33},{-114,12}}, color={0,0,127}));
  connect(R1.n,R2. p) annotation (
    Line(points={{132,36},{132,20}},                                  color = {0, 0, 255}));
  connect(voltageSensor.n,R2. n) annotation (
    Line(points={{4,-8},{132,-8},{132,0}},                color = {0, 0, 255}));
  connect(booleanStep.y,switch. control) annotation (Line(points={{183,-24},{
          206,-24},{206,10},{186,10}},
                                  color={255,0,255}));
  connect(switch.p,R2. p)
    annotation (Line(points={{174,20},{132,20}},color={0,0,255}));
  connect(R2.n,switch. n)
    annotation (Line(points={{132,0},{174,0}},  color={0,0,255}));
  connect(switch1.p, currentSensor1.n)
    annotation (Line(points={{88,62},{12,62}}, color={0,0,255}));
  connect(switch1.n,R1. p)
    annotation (Line(points={{108,62},{132,62},{132,56}},
                                                       color={0,0,255}));
  connect(R3.n,switch1. p)
    annotation (Line(points={{88,48},{88,62}}, color={0,0,255}));
  connect(R3.p,switch1. n)
    annotation (Line(points={{108,48},{108,62}},
                                               color={0,0,255}));
  connect(booleanStep1.y,switch1. control) annotation (Line(points={{77,88},{88,
          88},{88,74},{98,74}}, color={255,0,255}));
  connect(d, pwm.dutyCycle)
    annotation (Line(points={{-148,-64},{-90,-64}}, color={0,0,127}));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    uses(Modelica(version="3.2.3")));
end new_r;
