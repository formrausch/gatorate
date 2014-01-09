Gatorate
========

Closed, or not Closed?

Usage
-----

    ./bin/gatorate observe
    ./bin/gatorate web
    ./bin/gatorate console

The web interface ist available on http://localhost:9292

To connect to another gatorate install (console) just use

  ./bin/gatorate console -r 'redis://10.0.1.164:6379' -p 8888

  or

  ./bin/gatorate web -r 'redis://10.0.1.164:6379' -p 8888

Installation
------------


    bundle install




Important
---------

The wiringpi project must be installed
on the raspberry pi.

Download at

    https://projects.drogon.net/raspberry-pi/wiringpi/

or

    git clone git://git.drogon.net/wiringPi

Build via

    cd wiringPi
    ./build

