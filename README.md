# oocsi-processing

Processing Library for the [OOCSI](https://github.com/iddi/oocsi) platform.

This platform can connect Windows, Mac and Linux computers (running Java and Processing), devices (Arduino, Raspberry Pi and Gadgeteer),
Web brosers (via websockets) and mobile devices (iOS and Android).
Please refer to the general documentation to know more about connection possibilities.  

## Download

Find the latest version of the library here: [oocsi-processing.zip](dist/oocsi-processing.zip) (21kB)

Alternatively, you can browse the source code on GitHub or clone the GitHub repository and get started with the code.

## Installation

1. Extract the zip file into the Processing libraries directory
2. Restart Processing
3. Open the examples browser in Processing, look for the Libraries >> oocsi folder 


## How to use

Either use one of the examples from the Processing examples browser, or follow the short tutorial below.

Before starting with an OOCSI client running in Processing, you need to know how the OOCSI network looks like.
You will need an OOCSI server running either on your computer (_localhost_) or available from the network.
Also, any OOCSI client in the network is identified by a _unique name_, which serves also as an address if other clients in the OOCSI network want to messages. 


### Create an OOCSI client

Before you can send or receive messages, you will need to create an OOCSI client that connects to an OOCSI server (running at a specific address).
When creating the client, you will need to supply also a _unique name_, which can be used as a handle if others want to send messages to your client. 

Create a client that connects to an OOCSI server running on the local computer (running at _localhost_, see [here](https://https://github.com/iddi/oocsi/readme.md#running_local)):

	OOCSI oocsi = new OOCSI(this, "unique name", "localhost");    

Create a client that connects to an OOCSI server running at the address _oocsi.example.net_:

	OOCSI oocsi = new OOCSI(this, "unique name", "oocsi.example.net");

After this statement, the OOCSI client _oocsi_ can be used in Processing code to send or subscribe for messages.
Please keep an eye on the Processing console where OOCSI will print start messages and also error, in case something goes wrong. 


### Subscribe to OOCSI channel

OOCSI communications base on messages which are sent to channels or individual clients. For simplicity, clients are regarded as channels as well.
OOCSI clients like the one created above can subscribe to channels, and from then on will receive all messages that are sent to the chosen channels.
Also, clients will receive all messages that are sent to their specific channel.

	oocsi.subscribe("channel red"); 

This line will subscribe the client to the channel _channel red_. The client will receive all messages sent to that channel.
To actually receive something, the _handleOOCSIEvent_ function has to be in place: 

	void handleOOCSIEvent(OOCSIEvent message) {
		// print out all values in message
		println(message.keys());
	}
	
In this example, all contents of a message are printed to the Processing console. These _keys_ can be used to retrieve values from the message, for example:

	void handleOOCSIEvent(OOCSIEvent message) {
		// print out the "intensity" value in the message
		println(message.get("intensity"));
	}
	

### Send data to OOCSI channel

Sending data to the OOCSI network, for instance, to one specific channel or client is even easier: 

	oocsi.channel("channel red").data("intensity", 100).send();
 
Essentially, sending messages follows three steps: 

1. Select a channel, for example: "channel red"
2. Add data to the message, for example: "intensity" = 100
3. Send the message to OOCSI
 
This composed message will then be send via the connected OOCSI server to the respective channel or client, in this case to "channel red". 


### Full example

As a full example, we build a simple counter that will count from 0 up till the sketch is stopped.
In the _setup_ function, a connection to the OOCSI network is established with the handle "counterA", and after that,
an initial message with counter = 0 is sent to "counterA" via the OOCSI network. In the _handleOOCSIEvent_ function,
every time a message with a counter value is received, the sketch will send it out to handle "counterA" again with the counter increased by 1.
When pasting the following code into Processing and running it, the Processing console should show a fast sequence of increasing numbers.

	import nl.tue.id.oocsi.*;
	
	OOCSI oocsi;
	
	void setup () {	
	  oocsi = new OOCSI(this, "counterA", "localhost");
	  oocsi.channel("counterA").data("count", 0).send();
	}
	
	void handleOOCSIEvent(OOCSIEvent e) {
	  int count = e.getInt("count", 0);
	  println(count);
	  oocsi.channel("counterA").data("count", count + 1).send();
	}


### Other examples 

The OOCSI Processing plugin comes with 3 examples that demonstrate parts of the functionality.
All examples require an OOCSI server running on the same computer (running at _localhost_, see [here](https://https://github.com/iddi/oocsi/readme.md#running_local)).
The examples are available from the Processing examples browser, or below:

1. Client to client message sending _via a direct link_:
	- [DirectReceiver](dist/oocsi/examples/DirectReceiver/DirectReceiver.pde) (start this first)
	- [DirectSender](dist/oocsi/examples/DirectSender/DirectSender.pde) (move mouse over the window, receiver window should show a moving square)


2. Client to client message sending and receiving _via a channel_:
	- [ChannelReceiver](dist/oocsi/examples/ChannelReceiver/ChannelReceiver.pde) (start this first)
	- [ChannelSender](dist/oocsi/examples/ChannelSender/ChannelSender.pde) (move mouse over the window, receiver window should show a moving square)


3. Getting an updated list of all connected clients
	- [Tools_ClientLister](dist/oocsi/examples/Tools_ClientLister/Tools_ClientLister.pde)
	
