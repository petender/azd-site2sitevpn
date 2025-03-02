[comment]: <> (please keep all comment items at the top of the markdown file)
[comment]: <> (please do not change the ***, as well as <div> placeholders for Note and Tip layout)
[comment]: <> (please keep the ### 1. and 2. titles as is for consistency across all demoguides)
[comment]: <> (section 1 provides a bullet list of resources + clarifying screenshots of the key resources details)
[comment]: <> (section 2 provides summarized step-by-step instructions on what to demo)


[comment]: <> (this is the section for the Note: item; please do not make any changes here)
***
### Site to Site VPN across 3 Azure Regions - demo scenario

<div style="background: lightgreen; 
            font-size: 14px; 
            color: black;
            padding: 5px; 
            border: 1px solid lightgray; 
            margin: 5px;">

**Note:** Below demo steps should be used **as a guideline** for doing your own demos. Please consider contributing to add additional demo steps.
</div>

[comment]: <> (this is the section for the Tip: item; consider adding a Tip, or remove the section between <div> and </div> if there is no tip)

<div style="background: lightblue; 
            font-size: 14px; 
            color: black;
            padding: 5px; 
            border: 1px solid lightgray; 
            margin: 5px;">

**Tip:** The deployment of this scenario takes about 45min, so allocate enough time upfront your planned demo to make sure all got set up correctly and the VPN Connections are established.

</div>

***
### 1. What Resources are getting deployed
This scenario deploys 3 Azure Virtual Network (VPN) Gateways across 3 different regions (West Europe, Central US and East Asia), and establishes the cross-region VPN Connections.

* MTTDemoDeployRGc%youralias%VPN - Azure Resource Group.
* Each region holds the following resources:
    - gwx-unique -> Public IP Address for the gateway
    - vNetx-to-vNetx -> VPN Connection from one region to another
    - vNetx-Gateway -> Virtual Network Gateway
    - vNetx-location -> Virtual Network and Subnets for each region

<img src="https://raw.githubusercontent.com/petender/azd-site2sitevpn/refs/heads/main/Demoguides/S2SVPN/ResourceGroup_Overview.png" alt="S2S VPN Resource Group" style="width:70%;">
<br></br>

<img src="https://raw.githubusercontent.com/petender/azd-site2sitevpn/refs/heads/main/Demoguides/S2SVPN/VPN_Connections.png" alt="S2S VPN Connections" style="width:70%;">
<br></br>

<img src="https://raw.githubusercontent.com/petender/azd-site2sitevpn/refs/heads/main/Demoguides/S2SVPN/VPN_Gateways.png" alt="S2S VPN Gateways" style="width:70%;">
<br></br>

### 2. What can I demo from this scenario after deployment

This scenario is mainly to be used to highlight several of the VPN Gateway and Connection settings. Consider deploying a client or server VM in 2 different regions and show how network traffic connectivity is possible. 

1. Navigate to **VNet1-Gateway** Azure Resource. From the **Overview** blade, show how this VPN Gateway is connected to the **vNet1 Virtual Network**, as well as connected to a **Public IP Address** resource.
1. From Settings/**Configuration**, describe the **SKU** options, **ASN Number structure** and **BGP Peer IP address**.
1. From Settings/**Connections**, notice there are 2 Site-to-Site VPN connections live for this VPN Gateway, establishing a 2-way VPN connection between vNet1 and vNet2 in 2 different regions.
1. Select **vNet1-to-vNet2** Connection. 
1. From the **vNet1-to-vNet2** Connection blade, select Settings/**SharedKey**; explain this key must be the same between the sending/receiving connectors to establish the connection.

<img src="https://raw.githubusercontent.com/petender/azd-site2sitevpn/refs/heads/main/Demoguides/S2SVPN/VPN_SharedKey.png" alt="S2S VPN Shared Key" style="width:70%;">
<br></br>


1. From the **vNet1-to-vNet2** Connection blade, select Settings/**Configuration**, and explain several of the options here.

<img src="https://raw.githubusercontent.com/petender/azd-site2sitevpn/refs/heads/main/Demoguides/S2SVPN/VPN_Configuration.png" alt="S2S VPN Configuration" style="width:70%;">
<br></br>

<div style="background: lightblue; 
            font-size: 14px; 
            color: black;
            padding: 5px; 
            border: 1px solid lightgray; 
            margin: 5px;">

**Tip:** While all connections are active/connected, consider going into the Settings of an active connection before the live demo, and change the Shared Key *to something else* of a connection to have it in disconnected mode. This can be used to showcase a troubleshooting demo.
</div>

1. Navigate to the Connection where you changed the **Shared Key** on one end of the connection. Highlight the **Status** is showing **Disconnected**
1. Navigate to the **Virtual Network Gateway** of the failing/disconnected Connection.
1. Click **Advanced Troubleshooting**
1. Select the **vNetx-Gateway** with the failing/disconnected Connection. 
1. Specify a **Storage Account** and a **Container** which is used to store the troubleshooting logfiles. 
1. Click **Start Troubleshooting** to run the troubleshooting helper from **Network Watcher**.

<img src="https://raw.githubusercontent.com/petender/azd-site2sitevpn/refs/heads/main/Demoguides/S2SVPN/VPN_Troubleshooting.png" alt="S2S VPN Troubleshooting" style="width:70%;">
<br></br>


1. After a few minutes, Network Watcher indicates an **Unhealthy** vNetx-Gateway.
1. From the **Status** details below, it clearly identifies **The S2S VPN Tunnels could not connect because of a IKE or connectivity issues**, which could be translated as **Maybe your Shared Keys are not correct between both**.

<img src="https://raw.githubusercontent.com/petender/azd-site2sitevpn/refs/heads/main/Demoguides/S2SVPN/VPN_Troubleshooting2.png" alt="S2S VPN Troubleshooting" style="width:70%;">
<br></br>

[comment]: <> (this is the closing section of the demo steps. Please do not change anything here to keep the layout consistant with the other demoguides.)
<br></br>
***
<div style="background: lightgray; 
            font-size: 14px; 
            color: black;
            padding: 5px; 
            border: 1px solid lightgray; 
            margin: 5px;">

**Note:** This is the end of the current demo guide instructions.
</div>
