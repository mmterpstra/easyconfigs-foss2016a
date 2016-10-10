#!/usr/bin/env perl
use strict;
use warnings;
use File::Copy qw(copy);

#copy $old_file, $new_file;

print join("\n",glob("/data/umcg-mterpstra/apps//software/*/*/*/*.eb"))."\n";

for my $eb (glob("/data/umcg-mterpstra/apps//software/*/*/easybuild/*.eb")){
	chomp $eb;
	my $dname = `dirname $0`;
	chomp $dname;
	my $bname = `basename $eb`;
	chomp $bname;
	my $ebname = getebsoftwarename($eb) or die "Could not detect easybuild file software name of $eb";
	my $lcdir = lc($dname.'/'.substr($ebname,0,1));
	chomp $lcdir;
        if( ! -e $lcdir){
                mkdir $lcdir;
        }
	my $sfnamedir = $lcdir.'/'.$ebname;
	if( ! -e $sfnamedir){
                mkdir $sfnamedir;
        }
	my $ebtarget = $sfnamedir.'/'.$bname;
	if( ! -e $ebtarget){
		copy ($eb, $ebtarget );
	}else{
		die "$ebtarget already present.".`diff $ebtarget $eb`;
	}
}


#sub basename {
#	my $p = shift @_;
#	$p =~ s/[^\/]{1,}$//g;
#	return $p;
#}

sub getebsoftwarename {
	my $eb = shift(@_);
	my $ebname;
	open(my $ebh, '<', $eb) or die "Cannot open for read: $eb";
	while(<$ebh>){
		$ebname=$1 if(m/^name\s*=\s*['"]+(.*)['"]+/ ); 
	} 
	return $ebname;
}
