 /***********************************************************************
 
 Elements of Consumtion (EoC)
 
 Main program
 
 
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

import fullscreen.*;

final int EOC_NORMAL_CANVAS = 1;
final int EOC_INVERSE_CANVAS = 2;
final int SWARM_SIZE = 32;

ConsumptionData cdata;
FullScreen fslib;
AmbientDisplay display;
Canvas canvas1;
Canvas canvas2;
AlifeAgent[] alife;
SwarmAgent[] swarm;
int curCanvas;

void setup() 
{
  cdata = new ConsumptionData();
  cdata.start();
  
  fslib = new FullScreen(this);
  display = new AmbientDisplay(1920, 1080);

  canvas1 = new Canvas(1, true);  
  //canvas2 = new Canvas(2, false);  
  canvas2 = new Canvas(3, false);  
  curCanvas = EOC_NORMAL_CANVAS;

  alife = new AlifeAgent[3];
  swarm = new SwarmAgent[3 * SWARM_SIZE];
}

void draw()
{
  tendToLife(false);
  
  if(curCanvas == EOC_NORMAL_CANVAS)
  {
    for(int i = 0; i < alife.length; i++)
    {
      if(alife[i] != null)
        alife[i].update();
    }
    canvas1.update();
    canvas1.show();
  }
  else if(curCanvas == EOC_INVERSE_CANVAS)
  {
    for(int i = 0; i < swarm.length; i++)
    {
      if(swarm[i] != null)
        swarm[i].update();
    }
    canvas2.update();
    canvas2.show();
  }
}

void keyPressed() 
{
  switch(key)
  {
    case '1':
      curCanvas = EOC_NORMAL_CANVAS;
      frameRate(60);
      //tendToLife(true);
      break;

    case '2':
      curCanvas = EOC_INVERSE_CANVAS;
      //frameRate(30);
      frameRate(10);
      //tendToLife(true);
      break;
      
    case 'F':
    case 'f':
      fslib.enter();
      tendToLife(true);
      break;

    case 'E':
    case 'e':
      cdata.zeroOut(ELECTRICITY_DATA);
      tendToLife(true);
      break;

    case 'W':
    case 'w':
      cdata.zeroOut(WATER_DATA);
      tendToLife(true);
      break;

    case 'G':
    case 'g':
      cdata.zeroOut(NATURAL_GAS_DATA);
      tendToLife(true);
      break;

  }
  
  println(frameRate);
}

void tendToLife(boolean override)
{
  if(!cdata.available() && !override)
    return;
    
  for(int agentType = 1; agentType < 4; agentType++)
  {
    int diff = 0;
    int count = 0;
    
    count = 0;
    for(int i = 0; i < alife.length; i++) 
    {
      if(alife[i] != null && alife[i].type() == agentType)
        count++;
    }
    diff = cdata.accumUnits(agentType) - count;
    for(int j = diff; j > 0; j--)
    {
      int idx;
      for(idx = 0; idx < alife.length; idx++)
      {
        if(alife[idx] == null)
          break;
      }
      if(idx < alife.length)
        alife[idx] = new AlifeAgent(agentType, canvas1);
      else
        alife = (AlifeAgent [])append(alife, new AlifeAgent(agentType, canvas1));
    }
    for(int j = diff; j < 0; j++)
    {
      int idx = -1;
      long age = 0;
      for(int i = 0; i < alife.length; i++)
      {
        if(alife[i] != null && alife[i].type() == agentType && alife[i].age() > age)
        {
          idx = i;
          age = alife[i].age();
        }
      }      
      if(idx != -1)
        alife[idx] = null;
    }
    
    count = 0;
    for(int i = 0; i < swarm.length; i++) 
    {
      if(swarm[i] != null && swarm[i].type() == agentType)
        count++;
    }
    diff = cdata.instUnits(agentType, SWARM_SIZE, true) - count;
    for(int j = diff; j > 0; j--)
    {
      int idx;
      for(idx = 0; idx < swarm.length; idx++)
      {
        if(swarm[idx] == null)
          break;
      }
      if(idx < swarm.length)
        swarm[idx] = new SwarmAgent(agentType, canvas2);
      else
        swarm = (SwarmAgent [])append(swarm, new SwarmAgent(agentType, canvas2));
    }
    for(int j = diff; j < 0; j++)
    {
      int idx = -1;
      long age = 0;
      for(int i = 0; i < swarm.length; i++)
      {
        if(swarm[i] != null && swarm[i].type() == agentType && swarm[i].age() > age)
        {
          idx = i;
          age = swarm[i].age();
        }
      }    
      if(idx != -1)
        swarm[idx] = null;
    }
  }
  
  cdata.allRead();
}

