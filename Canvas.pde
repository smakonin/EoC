/***********************************************************************
 
 Elements of Consumtion (EoC)
 
 Canvas Class and Globals
 
 
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

import msafluid.*;

class Canvas
{
  MSAFluidSolver2D _fluidSolver;
  ParticleSystem _particleSystem;
  PImage _imgFluid;
  float _fluidWidth;
  boolean _showSparks;

  Canvas(float widthFactor, boolean showSparks)
  {
    // create fluid and set options
    _fluidWidth = 120 * widthFactor;
    _fluidSolver = new MSAFluidSolver2D((int)(_fluidWidth), (int)(_fluidWidth * height/width));
    _fluidSolver.enableRGB(true).setFadeSpeed(0.003).setDeltaT(0.5).setVisc(0.0001);
  
    // create image to hold fluid picture
    _imgFluid = createImage(_fluidSolver.getWidth(), _fluidSolver.getHeight(), RGB);
  
    // create particle system
    _particleSystem = new ParticleSystem(this);
    _showSparks = showSparks;
  }

  void update() 
  {
    
    _fluidSolver.update();
  
    for(int i = 0; i < _fluidSolver.getNumCells(); i++) 
    {
      int d = 2;
      _imgFluid.pixels[i] = color(_fluidSolver.r[i] * d, _fluidSolver.g[i] * d, _fluidSolver.b[i] * d);
    }  
    _imgFluid.updatePixels();
  }
  
  void show()
  {
    image(_imgFluid, 0, 0, width, height);
  
    if(_showSparks)
      _particleSystem.updateAndDraw();
  }
  
  MSAFluidSolver2D fluidSolver()
  {
    return _fluidSolver;
  }
  
  ParticleSystem particleSystem()
  {
    return _particleSystem;
  }
}

