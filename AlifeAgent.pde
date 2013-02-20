/***********************************************************************
 
 Elements of Consumtion (EoC)
 
 A-life Agents Class and Globals
 
 
/***********************************************************************
 * Copyright (C) 2011, Stephen Makonin. All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 *     * Redistributions of source code must retain the above copyright
 *       notice, this list of conditions and the following disclaimer.
 *     * Redistributions in binary form must reproduce the above copyright
 *       notice, this list of conditions and the following disclaimer in the
 *       documentation and/or other materials provided with the distribution.
 *     * Neither the name of MSA Visuals nor the names of its contributors 
 *       may be used to endorse or promote products derived from this software
 *       without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, 
 * THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS 
 * OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY
 * OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE 
 * OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
 * OF THE POSSIBILITY OF SUCH DAMAGE. 
 *
 * ***********************************************************************/

final int ELECTRICITY_ALIFE = 1;
final int WATER_ALIFE = 2;
final int NATURAL_GAS_ALIFE = 3;

class AlifeAgent 
{  
  Canvas _canvas;

  float _xPos;
  float _yPos;  
  float _xPosLast;  
  float _yPosLast;  
  float _xDir;
  float _yDir;
  float[] _xPoints = { 0, 0, 0, 0 };
  float[] _yPoints = { 0, 0, 0, 0 };
  float _walkPos;
  float _walkLen;
  float _slowness;

  float _radius;
  color _colourFill; 
  color _colourLine;

  int _type;
  long _age;

  AlifeAgent(int type, Canvas canvas)
  {
    _canvas = canvas;
    _age = 0;
    _type = type;
    _slowness = 1;

    for(int i = 0; i < 13; i++)
    {
      _xPos = random(0, width * 1000) / 1000;
      _yPos = random(0, height * 1000) / 1000;
    }

    if(_type == ELECTRICITY_ALIFE)
    {
      _xDir = 10;
      _yDir = 10;
    }
    else if(_type == WATER_ALIFE) 
    {
      _xDir = random(-1, 1);
      _yDir = random(-1, 1);
      //_slowness = 2;
    }
    else if(_type == NATURAL_GAS_ALIFE) 
    {
      _xDir = 2;
      _yDir = 2;
    }

    _radius = 10;
    _colourFill = color(agentHue(), 1, 1, 0.5);
    _colourLine = color(agentHue(), 1, 1, 1);

    initNewPath();
  }

  float agentHue()
  {
    float hueNo = 0;
    
    if(_type == ELECTRICITY_ALIFE) 
      hueNo = 45 + 120 * 0;
    else if(_type == WATER_ALIFE) 
      hueNo = 45 + 120 * 1;
    else if(_type == NATURAL_GAS_ALIFE) 
      hueNo = 45 + 120 * 2;

    return hueNo;
  }

  void initNewPath()
  {
    if(_type == ELECTRICITY_ALIFE) 
      initElectricityPath();
    else if(_type == WATER_ALIFE) 
      initWaterPath();
    else if(_type == NATURAL_GAS_ALIFE) 
      initNaturalGasPath();
  }

  void initElectricityPath()
  {
  }

  void initWaterPath()
  {
    _xPoints[0] = _xPos;
    _yPoints[0] = _yPos;

    for(int i = 0; i < 13; i++)
    {
      _xDir = random(-1, 1);
      _yDir = random(-1, 1);
      _xPoints[3] = _xPos + _xDir * 400;//random(300, 700) / 4;
      _yPoints[3] = _yPos + _yDir * 400;//random(300, 700) / 4;
    }
    
    float slope;
    if(_xPoints[0] == _xPoints[3])
      slope = 0;
    if(_yPoints[0] == _yPoints[3])
      slope = 0;
    else
      slope = abs(_yPoints[0] - _yPoints[3]) / abs(_xPoints[0] - _xPoints[3]);

    float xHalf = abs(_xPoints[0] - _xPoints[3]) / 2;
    float yHalf = abs(_yPoints[0] - _yPoints[3]) / 2;
    float slope2 = 1 / slope;
    float len = sqrt(sq(_yPoints[0] - _yPoints[3]) + sq(_xPoints[0] - _xPoints[3]));
    float rad90 = radians(90.0);

    _xPoints[1] = _xPoints[0]+ cos(rad90) * (_xPoints[3] - _xPoints[0]) - sin(rad90) * (_yPoints[3] - _yPoints[0]);
    _yPoints[1] = _yPoints[0] + sin(rad90) * (_xPoints[3] - _xPoints[0]) + cos(rad90) * (_yPoints[3] - _yPoints[0]);
    _xPoints[2] = _xPoints[3]+ cos(rad90) * (_xPoints[0] - _xPoints[3]) - sin(rad90) * (_yPoints[0] - _yPoints[3]);
    _yPoints[2] = _yPoints[3] + sin(rad90) * (_xPoints[0] - _xPoints[3]) + cos(rad90) * (_yPoints[0] - _yPoints[3]);

    float bezierLen = 0;
    float lx = _xPoints[0];
    float ly = _yPoints[0];
    for(int i = 1; i < 8; i++)
    {
      float t = map(i, 0, 8 - 1, 0, 1);
      float x = bezierPoint(_xPoints[0], _xPoints[1], _xPoints[2], _xPoints[3], t);
      float y = bezierPoint(_yPoints[0], _yPoints[1], _yPoints[2], _yPoints[3], t);

      bezierLen += sqrt(sq(x - lx) + sq(y - ly));

      lx = x;
      ly = y;
    }
    _walkLen = bezierLen * _slowness;
    _walkPos = 0;
  }

  void initNaturalGasPath()
  {
  }

  int type()
  {
    return _type;
  }
  
  long age()
  {
    return _age;
  }

  void update() 
  {

    if(_walkPos > _walkLen - 1)
      initNewPath();

    if(_type == ELECTRICITY_ALIFE)
    {
      if(_xPos < DISPLAY_BORDER / 2)
      {
        _xPos = (_xPos + random(-_xDir / 2, _xDir)) % width;
      }
      else if(_xPos > width - DISPLAY_BORDER / 2)
      {
        _xPos = (_xPos + random(-_xDir, _xDir / 2)) % width;
      }
      else
      {
        _xPos = (_xPos + random(-_xDir, _xDir)) % width;
      }
      
      if(_yPos < DISPLAY_BORDER / 2)
      {
        _yPos = (_yPos + random(-_yDir / 2, _yDir)) % height;
      }
      else if(_yPos > height - DISPLAY_BORDER / 2)
      {
        _yPos = (_yPos + random(-_yDir, _yDir / 2)) % height;
      }
      else
      {
        _yPos = (_yPos + random(-_yDir, _yDir)) % height;
      }      

      if(_xPos < 0) 
        _xPos = width + _xPos;
  
      if(_yPos < 0) 
        _yPos = height + _yPos;
    }
    else if(_type == WATER_ALIFE)
    {
      float t = map(_walkPos, 0, _walkLen - 1, 0, 1);
      _xPos = bezierPoint(_xPoints[0], _xPoints[1], _xPoints[2], _xPoints[3], t) % width;        
      _yPos = bezierPoint(_yPoints[0], _yPoints[1], _yPoints[2], _yPoints[3], t) % height;

      if(_xPos < 0) 
        _xPos = width + _xPos;
  
      if(_yPos < 0) 
        _yPos = height + _yPos;
    }
    else if(_type == NATURAL_GAS_ALIFE)
    {
      _xPos += _xDir;
      if ((_xPos < 0) || (_xPos > width)) 
        _xDir = -_xDir;

      _yPos += _yDir;
      if ((_yPos < 0) || (_yPos > height)) 
        _yDir = -_yDir;
    }
      
    // add force and dye to fluid, and create particles
    float x = _xPos * display.invWidth();
    float y = _yPos * display.invHeight();
    float dx = (_xPos - _xPosLast) * display.invWidth();
    float dy = (_yPos - _yPosLast) * display.invHeight();
    // balance the x and y components of speed with the screen aspect ratio
    float speed = dx * dx  + dy * dy * display.aspectRatio2();
  
    if(speed > 0) 
    {
      if(x < 0) 
        x = 0; 
      else if(x > 1) 
        x = 1;
      
      if(y < 0) 
        y = 0; 
      else if(y > 1) 
        y = 1;
  
      float colorMult = 5;
      float velocityMult = 30.0f;
  
      int index = _canvas.fluidSolver().getIndexForNormalizedPosition(x, y);
  
      colorMode(HSB, 360, 1, 1);
      color drawColor = color(agentHue(), 1, 0.5);
      colorMode(RGB, 1);  
  
      _canvas.fluidSolver().rOld[index]  += red(drawColor) * colorMult;
      _canvas.fluidSolver().gOld[index]  += green(drawColor) * colorMult;
      _canvas.fluidSolver().bOld[index]  += blue(drawColor) * colorMult;
  
      _canvas.particleSystem().addParticles(x * width, y * height, 10);
      _canvas.fluidSolver().uOld[index] += dx * velocityMult;
      _canvas.fluidSolver().vOld[index] += dy * velocityMult;
    }

    _age++;
    _walkPos++;
    _xPosLast = _xPos;
    _yPosLast = _yPos;
  }
  
  void showDebug()
  {
    //DEBIUG shapes
    fill(_colourFill);
    stroke(_colourLine);
    ellipse(_xPos, _yPos, _radius*2, _radius*2);
    line(_xPoints[0], _yPoints[0], _xPoints[1], _yPoints[1]);
    line(_xPoints[2], _yPoints[2], _xPoints[3], _yPoints[3]);
    line(_xPoints[0], _yPoints[0], _xPoints[3], _yPoints[3]);
    bezier(_xPoints[0], _yPoints[0], _xPoints[1], _yPoints[1], _xPoints[2], _yPoints[2], _xPoints[3], _yPoints[3]);
  }
}

