print "Content-type: text/html"
print
print "<html>"
print "<pre>"

import sys, os, cgi, pg

con = pg.connect(dbname='smarthome', host='localhost', user='theuser', passwd='???????')

for i in range(3):
    avg = 0.0
    min = 0.0
    max = 0.0
    stddev = 0.0
    rate = 0.0
    maxd = 0.0
    mind = 0.0
    avgd = 0.0
    stddevd = 0.0
    inst = 0.0

    home = "MAK"
    device = ""
    descr = ""

    try:
        if i == 0:
            device = "MHE"
            descr = "Electricity"
        elif i == 1:
            device = "MHW"
            descr = "Water"
        elif i == 2:
            device = "MHG"
            descr = "Natural Gas"

        sql = "select max(rate) as max, min(rate) as min, avg(rate) as avg, stddev_pop(rate) as stddev from (select date(gmt_ts), sum(period_rate) as rate from rawdata where home_id = '" + home + "' and device_id = '" + device + "' and period_rate != 0 and gmt_ts >= '2011-07-01 00:00:00 GMT' group by date(gmt_ts)) daily_rate;"
        for res in con.query(sql).dictresult():
            avg = res['avg']
            min = res['min']
            max = res['max']
            stddev = res['stddev']

        sql = "select sum(period_rate) as rate from rawdata where home_id = '" + home + "' and device_id = '" + device + "' and gmt_ts >= (select gmt_ts - interval '24 hours 1 minute' from rawdata order by gmt_ts desc limit 1);"
        for res in con.query(sql).dictresult():
            rate = res['rate']

        sql = "select max(instantaneous_rate) as max, min(instantaneous_rate) as min, avg(instantaneous_rate) as avg, stddev_pop(instantaneous_rate) as stddev from rawdata where home_id = '" + home + "' and device_id = '" + device + "' and instantaneous_rate != 0 ;";
        for res in con.query(sql).dictresult():
            maxd = res['max']
            mind = res['min']
            avgd = res['avg']
            stddevd = res['stddev']

        sql = "select instantaneous_rate as rate from rawdata where home_id = '" + home + "' and device_id = '" + device + "' order by gmt_ts desc limit 1;"
        for res in con.query(sql).dictresult():
            inst = res['rate']

    except:
        print "Error({0}): {1}".format(errno, strerror)

    print "%s: Daily Avg=%0.1f, Daily StdDev=%0.1f, Daily Min=%0.1f, Daily Max=%0.1f, Last 24hrs=%0.1f, Max Demand=%0.2f, Min Demand=%0.2f, Avg Demand=%0.2f, StdDev Demand=%0.2f, Current Demand=%0.2f" % (descr, avg, stddev, min, max, rate, maxd, mind, avgd, stddevd, inst)

con.close
print "</pre>"
print "</html>"
