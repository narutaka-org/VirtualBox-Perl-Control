# !/usr/bin/perl

#use utf8;	//内部文字にはしない
use strict;
use warnings;
use Data::Dumper;

my $Command  = "C:\\Program Files\\Oracle\\VirtualBox\\VBoxManage.exe";
#my $CNECTNIC = "NIC 2";
#my $NETNAME  = "VirtualBox Host-Only Ethernet Adapter";

##コンソールをUTF8に
my $COMMND1 = `chcp 65001`;

print "NanTarou VirtualBox Manage\n\n";

my @l_VPCLIST = ();
my %h_VPCUID  = ();
my %h_VPCMOVE = ();
my %h_No2Vpc  = ();

##VPCリスト
my $VL1 = `"$Command" list vms`;
if($VL1 eq "")
{
	print "VPCが存在しません。";
	exit;
}
my @VLS1 = split(/\n/, $VL1);
foreach (@VLS1)
{
	if ($_ =~ /"(.*)" \{(.*)\}/) 
	{
		push(@l_VPCLIST, $1);
		$h_VPCUID{$1} = $2;
		$h_VPCUID{$1} = "0";
	}
}

##VPC起動確認
my $VL2 = `"$Command" list runningvms`;
if($VL2 eq "")
{
	#print "VPCが起動していません。";
	#exit;
}
my @VLS2 = split(/\n/, $VL2);
foreach (@VLS2)
{
	if ($_ =~ /"(.*)" \{(.*)\}/) 
	{
		$h_VPCUID{$1} = "1";
	}
}

##
my $nomber = 1;
foreach (@l_VPCLIST)
{
	my $msgmove = "   ";
	if( $h_VPCUID{$_} ){ $msgmove = "run"; }
	if( $nomber < 10 )
	{
		print sprintf("  %d %s %s \n",$nomber,$msgmove,$_);
	}else{
		print sprintf(" %d %s %s \n",$nomber,$msgmove,$_);	#100からはズレるよw
	}
	$h_No2Vpc{$nomber} = $_;
	++$nomber;
}

##
print "\n終了する番号を入力してください。\n";
my $line = <STDIN>;
chomp($line);

##
my $wupname = $h_No2Vpc{$line};
if (defined($wupname))
{
	if( $wupname eq "" )
	{
		print "終了します。\n";
		exit;
	}
}else{
	print "終了します。\n";
	exit;
}

if( $h_VPCUID{$h_No2Vpc{$line}} eq "0" )
{
	print "すでに終了しています。\n";
	exit;
}

print "$wupname を終了しています。\n";
my $VL3 = `"$Command" startvm "$wupname" --type headless`;
#if($VL3 eq "")
#{
#	print "$wupnameの起動に失敗しました。";
#	exit;
#}

print "終了しました。システムが終了するまでしばらくお待ちください。\n";
print "終了します。\n";
exit;
