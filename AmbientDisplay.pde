/***********************************************************************
 
 Elements of Consumtion (EoC)
 
 Ambient Display Class and Globals
 
 
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

import processing.opengl.*;
import javax.media.opengl.*;

final int DISPLAY_BORDER = 50;
  
class AmbientDisplay
{
  float _invWidth;
  float _invHeight;
  float _aspectRatio;
  float _aspectRatio2;

  AmbientDisplay(int w, int h)
  {
    // Use OPENGL rendering for bilinear filtering on texture
    size(w, h, OPENGL);   
    // Turn on 4X antialiasing
    hint(ENABLE_OPENGL_4X_SMOOTH);    
  
    colorMode(HSB, 360, 1, 1, 1);
    
    frameRate(60);
  
    _invWidth = 1.0f/width;
    _invHeight = 1.0f/height;
    _aspectRatio = width * _invHeight;
    _aspectRatio2 = _aspectRatio * _aspectRatio;  
  }
  
  float invWidth()
  {
    return _invWidth;
  }
  
  float invHeight()
  {
    return _invHeight;
  }
  
  float aspectRatio()
  {
    return _aspectRatio;
  }
  
  float aspectRatio2()
  {
    return _aspectRatio2;
  }
}

