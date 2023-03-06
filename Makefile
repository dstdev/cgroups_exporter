PREFIX:=/usr/local
BINDIR:=/sbin

# these are set for RHEL based systems, modify to your needs
SYSTEMDUNITPATH:=/usr/lib/systemd/system
SYSTEMDENVPATH:=/etc/sysconfig
SYSTEMDUNIT:=cgroups_exporter.service
SYSTEMDENV:=cgroups_exporter

TARGET:=cgroups_exporter
SOURCES:=main.go cgroups/cgroups.go cgroups/cpuset.go cgroups/cpuacct.go cgroups/memory.go collectors/file.go collectors/slurm.go

$(TARGET): $(SOURCES)
	go build -o $@

clean:
	rm -f $(TARGET)

install:
	install $(TARGET) $(DESTDIR)$(PREFIX)$(BINDIR)/$(TARGET)
	cp systemd/$(SYSTEMDUNIT) $(SYSTEMDUNITPATH)/$(SYSTEMDUNIT)
	cp systemd/$(SYSTEMDENV).env $(SYSTEMDENVPATH)/$(SYSTEMDENV)

uninstall:
	systemctl stop $(TARGET)
	systemctl disable $(TARGET)
	rm -f $(DESTDIR)$(PREFIX)$(BINDIR)/$(TARGET)
	rm -f $(SYSTEMDUNITPATH)/$(SYSTEMDUNIT)
	rm -f $(SYSTEMDENVPATH)/$(SYSTEMDENV)

.PHONY: clean
