/***********************************************************************
 
 Elements of Consumtion (EoC)
 
 Consumption Data Class and Globals
 
 
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
 
final int ELECTRICITY_DATA = 1;
final int WATER_DATA = 2;
final int NATURAL_GAS_DATA = 3;

class ConsumptionData extends Thread 
{
  float[] _avg = { 0, 0, 0 };
  float[] _std = { 0, 0, 0 };
  float[] _min = { 0, 0, 0 };
  float[] _max = { 0, 0, 0 };
  float[] _sum = { 0, 0, 0 };

  float[] _maxd = { 0, 0, 0 };
  float[] _mind = { 0, 0, 0 };
  float[] _avgd = { 0, 0, 0 };
  float[] _stdd = { 0, 0, 0 };
  float[] _inst = { 0, 0, 0 };

  boolean[] _pulse = { false, true, true };
  
  boolean _available;
  boolean _running;
  int _lastMin;

  ConsumptionData()
  {
  }
  
  void start()
  {
    _available = false;
    _running = true;
    _lastMin = -1;
    super.start();
  }
  
  //public 
  void run()
  {
    String[] lines;

    while(_running)
    {
      int tmin = minute();
      int tsec = second();
      
      if((tmin != _lastMin && tsec == 0) || _lastMin == -1)
      {
        _available = false;
        lines = loadStrings("http://your-web-db-server/eocWebserice.py");
        
        for(int i = 2; i < 5; i++)
        {
          String[] p = splitTokens(lines[i], ":=,\r\n");   
          _avg[i - 2] = float(trim(p[2]));
          _std[i - 2] = float(trim(p[4]));
          _min[i - 2] = float(trim(p[6]));
          _max[i - 2] = float(trim(p[8]));
          _sum[i - 2] = float(trim(p[10]));
          _maxd[i - 2] = float(trim(p[12]));
          _mind[i - 2] = float(trim(p[14]));
          _avgd[i - 2] = float(trim(p[16]));
          _stdd[i - 2] = float(trim(p[18]));
          _inst[i - 2] = float(trim(p[20]));
        }
  
        _available = true;
        _lastMin = tmin;
      }
      delay(100);
    }
  }

  boolean available()
  {
    return _available;
  }
  
  int accumUnits(int type)
  {
      return ceil(_sum[type - 1] / _avg[type - 1]);
  }
  
  void zeroOut(int type)
  {
      _inst[type - 1] = _avgd[type - 1] + _stdd[type - 1] * 1.8;
  }
  
  int instUnits(int type, int scaler, boolean useInverse)
  {
      print(" pulse=");
      print(_pulse[type - 1]);
    
      print(" md=");
      print(_maxd[type - 1]);

      print(" avg=");
      print(_avgd[type - 1]);

      print(" stddev=");
      print(_stdd[type - 1]);

      print(" inst=");
      print(_inst[type - 1]);

      float minst = _inst[type - 1];
      if(!_pulse[type - 1])
        minst = _inst[type - 1] - (_avgd[type - 1] / 2);
      if(minst < 0.0)
        minst = 0.0;
        
      print(" minst=");
      print(minst);

      float theLimit = _avgd[type - 1] + _stdd[type - 1] * 1.8;
      print(" limit=");
      print(theLimit);
      
      print(" %=");
      float percent = minst / theLimit;      
      if(useInverse)
        percent = 1 - percent;
      print(percent*100);

      float units = float(scaler) * percent;
      if(units <= 0.0)
      {
        units = 0.0;
        if(minst < _maxd[type - 1])
          units = 1.0;
      } 
      if(units <= 1.0)
        units = 1.0;
        
      print(" units=");      
      print(units);
      println(" ");
      
      return floor(units);
  }

  void allRead()
  {
    _available = false;
  }
}


 


