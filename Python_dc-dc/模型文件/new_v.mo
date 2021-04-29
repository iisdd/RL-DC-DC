within ;
model new_v
  Modelica.Electrical.PowerConverters.DCDC.ChopperStepUp boost annotation (
    Placement(visible = true, transformation(origin={-84,2},     extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Basic.Inductor inductor(L=0.002)   annotation (
    Placement(visible = true, transformation(origin={-156,40},    extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Basic.Ground ground annotation (
    Placement(visible = true, transformation(origin={-178,-50},    extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.PowerConverters.DCDC.Control.SignalPWM pwm(
    constantDutyCycle=0.2,
    f=10000,
    startTime=0,
    useConstantDutyCycle=false)                                                                                                                   annotation (
    Placement(visible = true, transformation(origin={-84,-68},    extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Sensors.CurrentSensor currentSensor annotation (
    Placement(visible = true, transformation(origin={-120,40},    extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Basic.Capacitor capacitor(C=0.0015, v(start=170))      annotation (
    Placement(visible = true, transformation(origin={-34,-2},    extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Electrical.Analog.Sensors.VoltageSensor voltageSensor annotation (
    Placement(visible = true, transformation(origin={-2,-2},    extent = {{-10, 10}, {10, -10}}, rotation = -90)));
  Modelica.Electrical.Analog.Sensors.CurrentSensor currentSensor1 annotation (
    Placement(visible = true, transformation(origin={-4,58},   extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput d annotation (
    Placement(visible = true, transformation(origin={-154,-68},    extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin={-148,-64},    extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput i_l annotation (
    Placement(visible = true, transformation(origin={-120,8},    extent = {{-10, -10}, {10, 10}}, rotation=-90), iconTransformation(origin={-102,38},   extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput v_o annotation (
    Placement(visible = true, transformation(origin={32,-2},    extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin={38,2},     extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput i_o annotation (
    Placement(visible = true, transformation(origin={20,40},    extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin={26,44},    extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Basic.Resistor R1(R=1000)   annotation (
    Placement(visible = true, transformation(origin={126,26},   extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Sources.Constant const(k=0.22)
    annotation (Placement(transformation(extent={{-128,-80},{-108,-60}})));
  Modelica.Electrical.Analog.Sources.StepVoltage stepVoltage(
    V=-10,
    offset=85,
    startTime=0.3) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-192,26})));
  Modelica.Electrical.Analog.Sources.StepVoltage stepVoltage1(
    V=20,
    offset=0,
    startTime=0.7) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-192,0})));
equation
  connect(pwm.fire,boost. fire_p) annotation (
    Line(points={{-90,-57},{-90,-10}},     color = {255, 0, 255}));
  connect(boost.dc_p2,capacitor. p) annotation (
    Line(points={{-74,8},{-34,8}},                              color = {0, 0, 255}));
  connect(boost.dc_n2,capacitor. n) annotation (
    Line(points={{-74,-4},{-58,-4},{-58,-12},{-34,-12}},                color = {0, 0, 255}));
  connect(capacitor.p,voltageSensor. p) annotation (
    Line(points={{-34,8},{-2,8}},                            color = {0, 0, 255}));
  connect(capacitor.n,voltageSensor. n) annotation (
    Line(points={{-34,-12},{-2,-12}},  color = {0, 0, 255}));
  connect(voltageSensor.v,v_o)  annotation (
    Line(points={{9,-2},{32,-2}},                           color = {0, 0, 127}));
  connect(capacitor.p,currentSensor1. p) annotation (
    Line(points={{-34,8},{-34,58},{-14,58}},        color = {0, 0, 255}));
  connect(currentSensor1.i,i_o)  annotation (
    Line(points={{-4,47},{-4,40},{20,40}},                         color = {0, 0, 127}));
  connect(inductor.n,currentSensor. p)
    annotation (Line(points={{-146,40},{-130,40}}, color={0,0,255}));
  connect(currentSensor.n,boost. dc_p1) annotation (Line(points={{-110,40},{
          -102,40},{-102,8},{-94,8}},
                                  color={0,0,255}));
  connect(i_l,i_l)
    annotation (Line(points={{-120,8},{-120,8}},   color={0,0,127}));
  connect(currentSensor.i,i_l)
    annotation (Line(points={{-120,29},{-120,8}},  color={0,0,127}));
  connect(stepVoltage.p, inductor.p) annotation (Line(points={{-192,36},{-180,
          36},{-180,40},{-166,40}}, color={0,0,255}));
  connect(stepVoltage.n, stepVoltage1.p)
    annotation (Line(points={{-192,16},{-192,10}}, color={0,0,255}));
  connect(stepVoltage1.n, boost.dc_n1) annotation (Line(points={{-192,-10},{
          -144,-10},{-144,-4},{-94,-4}}, color={0,0,255}));
  connect(stepVoltage1.n, ground.p) annotation (Line(points={{-192,-10},{-186,
          -10},{-186,-40},{-178,-40}}, color={0,0,255}));
  connect(currentSensor1.n, R1.p)
    annotation (Line(points={{6,58},{126,58},{126,36}}, color={0,0,255}));
  connect(R1.n, voltageSensor.n)
    annotation (Line(points={{126,16},{126,-12},{-2,-12}}, color={0,0,255}));
  connect(const.y, pwm.dutyCycle) annotation (Line(points={{-107,-70},{-102,-70},
          {-102,-68},{-96,-68}}, color={0,0,127}));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    uses(Modelica(version="3.2.3")));
end new_v;
