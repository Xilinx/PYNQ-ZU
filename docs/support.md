---
layout: default
---

# PYNQ-ZU support

## PYNQ support

Questions about using PYNQ on the PYNQ-ZU can be posted to the PYNQ support forum:

* [https://discuss.pynq.io](https://discuss.pynq.io)

You can also post your own projects in the [Community Corner](https://discuss.pynq.io/c/community-projects-chat/14) on the PYNQ support forum. 



## Xilinx support

Questions related to Xilinx tools and building designs for your board, including HLS design, can be posted on the Xilinx technical support forums:

* [https://forums.xilinx.com](https://forums.xilinx.com)



## Hardware problems

Follow the troubleshooting guide below, and post questions on the [PYNQ support forum](https://discuss.pynq.io/). If you have a problem with you board and you suspect the board is damaged, please contact the manufacturer [TUL](https://www.tul.com.tw/).



## Troubleshooting

Check the [PYNQ Documentation](http://pynq.readthedocs.io/) for FAQs related to PYNQ. 



## PYNQ-ZU FAQ

* **I do not see any LEDs after turning on the board**

  This indicates there is no power going to the board, or the board is dead.

  * Check the power cables, and switches

  * Check the power switch is in the correct position

* **The PS-STATUS LED is RED**

  This indicates the PS is not booting the PYNQ image

  * Check the SD card is inserted, and has a valid PYNQ image

* **I do not see the DONE LED or the white flashing LEDs**

  This indicates the PS has not booted properly. 

  * Check the SD card has a valid PYNQ image

  * Connect a serial terminal and check the boot console

    If the boot process stalls, or continuously restarts, try to capture the console information and post it to the [PYNQ support forum](https://discuss.pynq.io). 

* **I have no Ethernet connection/I do not see the new connection on my computer**

  * On your host computer, check if a new Ethernet device is available in your network connections. You may need to check hardware manager in Windows, and the equivalent in other operating systems, to see if the Ethernet device was recognized, and if the driver was automatically loaded.  

  * Check the Micro USB 3.0 cable is connected to your host PC and board.

* **I cannot connect to Jupyter**

  * I get a "404" or the webpage for the board doesn't load

  * Connect a serial terminal, and check the boot log. Check if Jupyter Notebook server has started, and that it is still running. 

    You can do this by checking if the following command returns something:

    `ps -ef | grep Jupyter` 

    e.g. 

    ```
    root    1434  1405  0 09:16 pts/0   00:00:00
    ```

  

