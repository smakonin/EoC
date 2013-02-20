/***********************************************************************
 
 Elements of Consumtion (EoC)
 
 Swarm Agents Class and Globals
 
 
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

final int ELECTRICITY_AGENT = 1;
final int WATER_AGENT = 2;
final int NATURAL_GAS_AGENT = 3;

int global_pos = 0;

class SwarmAgent 
{  
  Canvas _canvas;

  float _xPos;
  float _yPos;  
  float _xPosLast;  
  float _yPosLast;  
  float _xDir;
  float _yDir;

  int _type;
  long _age;

  SwarmAgent(int type, Canvas canvas)
  {
    _canvas = canvas;
    _age = 0;
    _type = type;

    for(int i = 0; i < 13; i++)
    {
      _xPos = random(0, width * 1000) / 1000;
      _yPos = random(0, height * 1000) / 1000;
    }

    switch(global_pos % 4)
    {
      case 0:
        _xDir = 2;
        _yDir = 2;
        break;

      case 1:
        _xDir = -2;
        _yDir = 2;
        break;

      case 2:
        _xDir = 2;
        _yDir = -2;
        break;

      case 3:
        _xDir = -2;
        _yDir = -2;
        break;
    }
    
    global_pos++;
  }

  float agentHue()
  {
    float hueNo = 0;
    
    if(_type == ELECTRICITY_AGENT) 
      hueNo = 45 + 120 * 0;
    else if(_type == WATER_AGENT) 
      hueNo = 45 + 120 * 1;
    else if(_type == NATURAL_GAS_AGENT) 
      hueNo = 45 + 120 * 2;

    return hueNo;
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
    _xPos += _xDir;
    if ((_xPos < 0) || (_xPos > width)) 
      _xDir = -_xDir;

    _yPos += _yDir;
    if ((_yPos < 0) || (_yPos > height)) 
      _yDir = -_yDir;
      
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
      color drawColor = color(agentHue(), 1, 0.1);
      colorMode(RGB, 1);  
  
      _canvas.fluidSolver().rOld[index]  += red(drawColor) * colorMult;
      _canvas.fluidSolver().gOld[index]  += green(drawColor) * colorMult;
      _canvas.fluidSolver().bOld[index]  += blue(drawColor) * colorMult;
  
      _canvas.particleSystem().addParticles(x * width, y * height, 10);
      _canvas.fluidSolver().uOld[index] += dx * velocityMult;
      _canvas.fluidSolver().vOld[index] += dy * velocityMult;
    }

    _age++;
    _xPosLast = _xPos;
    _yPosLast = _yPos;
  }  
}

