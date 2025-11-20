# !/usr/bin/perl

#use utf8;	//内部文字にはしない
use strict;
use warnings;
use Data::Dumper;

my $Command  = "C:\\Program Files\\Oracle\\VirtualBox\\VBoxManage.exe";
my $CNECTNIC = "NIC 2";
my $NETNAME  = "VirtualBox Host-Only Ethernet Adapter";

##コンソールをUTF8に
my $COMMND1 = `chcp 65001`;

my @l_VPCLIST = ();
my %h_VPCUID  = ();
my %h_Nic2Vpc = ();
my %h_Nic2IP  = ();

##VPC起動リスト
my $VL = `"$Command" list runningvms`;
if($VL eq "")
{
	print "起動していない";
	exit;
}

##
my @VLS = split(/\n/, $VL);
foreach (@VLS)
{
	if ($_ =~ /"(.*)" \{(.*)\}/) 
	{
		my $vpcname = $1;
		push(@l_VPCLIST, $1);
		$h_VPCUID{$1} = $2;
		
		my $NICL = `"$Command" showvminfo --details $2`;
		
		my @NICLS = split(/\n/, $NICL);
		foreach (@NICLS)
		{
			if ($_ =~ /^$CNECTNIC:(.*)/) 
			{
				my $NICD = $1;
				my @NICDS = split(/,/, $NICD);
				foreach (@NICDS)
				{
					if ($_ =~ /MAC:(.*)/) 
					{
						my $tmp = $1;
						$tmp =~ s/^\s+//;
						$h_Nic2Vpc{$vpcname} = $tmp;
					}
				}
			}
		}
	}
}

##
foreach (@l_VPCLIST)
{
	my $vpcname = $_;
	my $NPCIP = `"$Command" dhcpserver findlease --interface "$NETNAME" --mac-address=$h_Nic2Vpc{$vpcname}`;
	my @NPCIPLS = split(/\n/, $NPCIP);
	foreach (@NPCIPLS)
	{
		if ($_ =~ /^IP Address:(.*)/) 
		{
			my $tmp = $1;
			$tmp =~ s/^\s+//;
			$h_Nic2IP{$vpcname} = $tmp;
		}
	}
}

##
my $nomber = 1;
foreach (@l_VPCLIST)
{
	my $ip = $h_Nic2IP{$_};
	if( $nomber < 10 )
	{
		print sprintf("  %d  %s  %s \n",$nomber,$ip,$_);
	}else{
		print sprintf(" %d  %s  %s \n",$nomber,$ip,$_);	#100からはズレるよw
	}
	++$nomber;
}





