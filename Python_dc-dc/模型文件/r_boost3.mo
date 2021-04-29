within ;
model r_boost3

  Modelica.Electrical.Analog.Sources.ConstantVoltage constantVoltage(V=80)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-170,14})));
  Modelica.Electrical.PowerConverters.DCDC.ChopperStepUp boost annotation (
    Placement(visible = true, transformation(origin={-76,10},    extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Basic.Inductor inductor(L=0.0068)  annotation (
    Placement(visible = true, transformation(origin={-148,48},    extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Basic.Ground ground annotation (
    Placement(visible = true, transformation(origin={-170,-42},    extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.PowerConverters.DCDC.Control.SignalPWM pwm(
    constantDutyCycle=0.2,
    f=10000,
    startTime=0,
    useConstantDutyCycle=false)                                                                                                                   annotation (
    Placement(visible = true, transformation(origin={-76,-60},    extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Sensors.CurrentSensor currentSensor annotation (
    Placement(visible = true, transformation(origin={-112,48},    extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Basic.Capacitor capacitor(C=0.0018, v(start=170))      annotation (
    Placement(visible = true, transformation(origin={-26,6},     extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Electrical.Analog.Sensors.VoltageSensor voltageSensor annotation (
    Placement(visible = true, transformation(origin={6,6},      extent = {{-10, 10}, {10, -10}}, rotation = -90)));
  Modelica.Electrical.Analog.Sensors.CurrentSensor currentSensor1 annotation (
    Placement(visible = true, transformation(origin={2,64},    extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Basic.Resistor R1(R=500)    annotation (
    Placement(visible = true, transformation(origin={90,48},    extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Electrical.Analog.Basic.Resistor R2(R=500)    annotation (
    Placement(visible = true, transformation(origin={90,12},    extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Sources.BooleanStep booleanStep(startTime=0.3)   annotation (
    Placement(visible = true, transformation(origin={130,-28},   extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Ideal.IdealClosingSwitch switch annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={120,12})));
  Modelica.Blocks.Sources.Constant const(k=0.5294)
    annotation (Placement(transformation(extent={{-166,-84},{-146,-64}})));
  Modelica.Blocks.Interfaces.RealInput d annotation (
    Placement(visible = true, transformation(origin={-116,-60},    extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-130, -48}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput i_l annotation (
    Placement(visible = true, transformation(origin={-112,16},   extent = {{-10, -10}, {10, 10}}, rotation=-90), iconTransformation(origin={-102,38},   extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput v_o annotation (
    Placement(visible = true, transformation(origin={40,6},     extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {44, 18}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput i_o annotation (
    Placement(visible = true, transformation(origin={28,48},    extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {32, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Basic.Resistor R3(R=500)    annotation (
    Placement(visible = true, transformation(origin={56,50},    extent = {{-10, -10}, {10, 10}}, rotation=180)));
  Modelica.Electrical.Analog.Ideal.IdealOpeningSwitch switch1
    annotation (Placement(transformation(extent={{46,54},{66,74}})));
  Modelica.Blocks.Sources.BooleanStep booleanStep1(startTime=0.7)  annotation (
    Placement(visible = true, transformation(origin={24,90},     extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(constantVoltage.p,inductor. p) annotation (
    Line(points={{-170,24},{-170,48},{-158,48}},        color = {0, 0, 255}));
  connect(constantVoltage.n,ground. p) annotation (
    Line(points={{-170,4},{-170,-32}},                                color = {0, 0, 255}));
  connect(constantVoltage.n,boost. dc_n1) annotation (
    Line(points={{-170,4},{-86,4}},        color = {0, 0, 255}));
  connect(pwm.fire,boost. fire_p) annotation (
    Line(points={{-82,-49},{-82,-2}},      color = {255, 0, 255}));
  connect(boost.dc_p2,capacitor. p) annotation (
    Line(points={{-66,16},{-26,16}},                            color = {0, 0, 255}));
  connect(boost.dc_n2,capacitor. n) annotation (
    Line(points={{-66,4},{-50,4},{-50,-4},{-26,-4}},                    color = {0, 0, 255}));
  connect(capacitor.p,voltageSensor. p) annotation (
    Line(points={{-26,16},{6,16}},                           color = {0, 0, 255}));
  connect(capacitor.n,voltageSensor. n) annotation (
    Line(points={{-26,-4},{6,-4}},     color = {0, 0, 255}));
  connect(voltageSensor.v,v_o)  annotation (
    Line(points={{17,6},{40,6}},                            color = {0, 0, 127}));
  connect(capacitor.p,currentSensor1. p) annotation (
    Line(points={{-26,16},{-26,64},{-8,64}},        color = {0, 0, 255}));
  connect(currentSensor1.i,i_o)  annotation (
    Line(points={{2,53},{2,48},{28,48}},                           color = {0, 0, 127}));
  connect(R1.n,R2. p) annotation (
    Line(points={{90,38},{90,22}},                                    color = {0, 0, 255}));
  connect(voltageSensor.n,R2. n) annotation (
    Line(points={{6,-4},{90,-4},{90,2}},                  color = {0, 0, 255}));
  connect(inductor.n,currentSensor. p)
    annotation (Line(points={{-138,48},{-122,48}}, color={0,0,255}));
  connect(currentSensor.n,boost. dc_p1) annotation (Line(points={{-102,48},{-94,
          48},{-94,16},{-86,16}}, color={0,0,255}));
  connect(i_l,i_l)
    annotation (Line(points={{-112,16},{-112,16}}, color={0,0,127}));
  connect(currentSensor.i,i_l)
    annotation (Line(points={{-112,37},{-112,16}}, color={0,0,127}));
  connect(booleanStep.y,switch. control) annotation (Line(points={{141,-28},{
          156,-28},{156,12},{132,12}},
                                  color={255,0,255}));
  connect(switch.p,R2. p)
    annotation (Line(points={{120,22},{90,22}}, color={0,0,255}));
  connect(R2.n,switch. n)
    annotation (Line(points={{90,2},{120,2}},   color={0,0,255}));
  connect(switch1.p, currentSensor1.n)
    annotation (Line(points={{46,64},{12,64}}, color={0,0,255}));
  connect(switch1.n, R1.p)
    annotation (Line(points={{66,64},{90,64},{90,58}}, color={0,0,255}));
  connect(R3.n, switch1.p)
    annotation (Line(points={{46,50},{46,64}}, color={0,0,255}));
  connect(R3.p, switch1.n)
    annotation (Line(points={{66,50},{66,64}}, color={0,0,255}));
  connect(booleanStep1.y, switch1.control) annotation (Line(points={{35,90},{46,
          90},{46,76},{56,76}}, color={255,0,255}));
  connect(pwm.dutyCycle, d)
    annotation (Line(points={{-88,-60},{-116,-60}}, color={0,0,127}));
  annotation (uses(Modelica(version="3.2.3")));
end r_boost3;
