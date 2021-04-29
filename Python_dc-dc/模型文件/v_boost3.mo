within ;
model v_boost3
  Modelica.Electrical.PowerConverters.DCDC.ChopperStepUp boost annotation (
    Placement(visible = true, transformation(origin={-98,6},     extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Basic.Inductor inductor(L=0.0068)  annotation (
    Placement(visible = true, transformation(origin={-170,44},    extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Basic.Ground ground annotation (
    Placement(visible = true, transformation(origin={-192,-46},    extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.PowerConverters.DCDC.Control.SignalPWM pwm(
    constantDutyCycle=0.2,
    f=10000,
    startTime=0,
    useConstantDutyCycle=false)                                                                                                                   annotation (
    Placement(visible = true, transformation(origin={-98,-64},    extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Sensors.CurrentSensor currentSensor annotation (
    Placement(visible = true, transformation(origin={-134,44},    extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Basic.Capacitor capacitor(C=0.0018, v(start=170))      annotation (
    Placement(visible = true, transformation(origin={-48,2},     extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Electrical.Analog.Sensors.VoltageSensor voltageSensor annotation (
    Placement(visible = true, transformation(origin={-16,2},    extent = {{-10, 10}, {10, -10}}, rotation = -90)));
  Modelica.Electrical.Analog.Sensors.CurrentSensor currentSensor1 annotation (
    Placement(visible = true, transformation(origin={-20,60},  extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Basic.Resistor R1(R=1000)   annotation (
    Placement(visible = true, transformation(origin={68,44},    extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Sources.Constant const(k=0.5294)
    annotation (Placement(transformation(extent={{-188,-88},{-168,-68}})));
  Modelica.Blocks.Interfaces.RealInput d annotation (
    Placement(visible = true, transformation(origin={-160,-60},    extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-130, -48}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput i_l annotation (
    Placement(visible = true, transformation(origin={-134,12},   extent = {{-10, -10}, {10, 10}}, rotation=-90), iconTransformation(origin={-102,38},   extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput v_o annotation (
    Placement(visible = true, transformation(origin={18,2},     extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {44, 18}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput i_o annotation (
    Placement(visible = true, transformation(origin={6,44},     extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {32, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Sources.StepVoltage stepVoltage(
    V=-10,
    offset=80,
    startTime=0.3) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-234,20})));
  Modelica.Electrical.Analog.Sources.StepVoltage stepVoltage1(
    V=20,
    offset=0,
    startTime=0.7) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-234,-8})));
  Modelica.Electrical.Analog.Sensors.VoltageSensor voltageSensor1
                                                                 annotation (
    Placement(visible = true, transformation(origin={-188,10},  extent = {{-10, 10}, {10, -10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealOutput v_source annotation (Placement(
      visible=true,
      transformation(
        origin={-158,6},
        extent={{-10,-10},{10,10}},
        rotation=-90),
      iconTransformation(
        origin={-102,38},
        extent={{-10,-10},{10,10}},
        rotation=0)));
equation
  connect(pwm.fire,boost. fire_p) annotation (
    Line(points={{-104,-53},{-104,-6}},    color = {255, 0, 255}));
  connect(boost.dc_p2,capacitor. p) annotation (
    Line(points={{-88,12},{-48,12}},                            color = {0, 0, 255}));
  connect(boost.dc_n2,capacitor. n) annotation (
    Line(points={{-88,0},{-72,0},{-72,-8},{-48,-8}},                    color = {0, 0, 255}));
  connect(capacitor.p,voltageSensor. p) annotation (
    Line(points={{-48,12},{-16,12}},                         color = {0, 0, 255}));
  connect(capacitor.n,voltageSensor. n) annotation (
    Line(points={{-48,-8},{-16,-8}},   color = {0, 0, 255}));
  connect(voltageSensor.v,v_o)  annotation (
    Line(points={{-5,2},{18,2}},                            color = {0, 0, 127}));
  connect(capacitor.p,currentSensor1. p) annotation (
    Line(points={{-48,12},{-48,60},{-30,60}},       color = {0, 0, 255}));
  connect(currentSensor1.i,i_o)  annotation (
    Line(points={{-20,49},{-20,44},{6,44}},                        color = {0, 0, 127}));
  connect(inductor.n,currentSensor. p)
    annotation (Line(points={{-160,44},{-144,44}}, color={0,0,255}));
  connect(currentSensor.n,boost. dc_p1) annotation (Line(points={{-124,44},{
          -116,44},{-116,12},{-108,12}},
                                  color={0,0,255}));
  connect(i_l,i_l)
    annotation (Line(points={{-134,12},{-134,12}}, color={0,0,127}));
  connect(currentSensor.i,i_l)
    annotation (Line(points={{-134,33},{-134,12}}, color={0,0,127}));
  connect(currentSensor1.n, R1.p) annotation (Line(points={{-10,60},{30,60},{30,
          54},{68,54}}, color={0,0,255}));
  connect(R1.n, voltageSensor.n) annotation (Line(points={{68,34},{28,34},{28,
          -8},{-16,-8}}, color={0,0,255}));
  connect(voltageSensor1.n, boost.dc_n1) annotation (Line(points={{-188,
          3.55271e-15},{-202,3.55271e-15},{-202,-20},{-172,-20},{-172,0},{-108,
          0}}, color={0,0,255}));
  connect(voltageSensor1.v, v_source) annotation (Line(points={{-177,10},{-168,
          10},{-168,6},{-158,6}}, color={0,0,127}));
  connect(stepVoltage.n, stepVoltage1.p)
    annotation (Line(points={{-234,10},{-234,2}}, color={0,0,255}));
  connect(stepVoltage1.n, boost.dc_n1) annotation (Line(points={{-234,-18},{
          -218,-18},{-218,-20},{-172,-20},{-172,0},{-108,0}}, color={0,0,255}));
  connect(ground.p, boost.dc_n1) annotation (Line(points={{-192,-36},{-198,-36},
          {-198,-20},{-172,-20},{-172,0},{-108,0}}, color={0,0,255}));
  connect(stepVoltage.p, inductor.p) annotation (Line(points={{-234,30},{-208,
          30},{-208,44},{-180,44}}, color={0,0,255}));
  connect(voltageSensor1.p, stepVoltage.p) annotation (Line(points={{-188,20},{
          -212,20},{-212,30},{-234,30}}, color={0,0,255}));
  connect(d, pwm.dutyCycle) annotation (Line(points={{-160,-60},{-136,-60},{
          -136,-64},{-110,-64}}, color={0,0,127}));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    uses(Modelica(version="3.2.3")));
end v_boost3;
