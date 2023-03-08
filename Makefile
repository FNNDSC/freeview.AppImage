APPIMAGETOOL_URL=https://github.com/AppImage/AppImageKit/releases/download/continuous/appimagetool-x86_64.AppImage
APPIMAGETOOL=appimagetool-x86_64.AppImage


freeview.AppImage: freeview.AppDir $(APPIMAGETOOL)
	./$(APPIMAGETOOL) $< $@

freeview.AppDir: res freesurfer-copied-binaries
	mkdir -v $@
	cp -rv res/* freesurfer-copied-binaries/* $@

freesurfer-copied-binaries:
	./extract_freeview_binaries.sh

$(APPIMAGETOOL):
	wget -O $@ $(APPIMAGETOOL_URL)
	chmod +x $(APPIMAGETOOL)

clean:
	$(RM) -r freeview.AppImage freeview.AppDir freesurfer-copied-binaries

.PHONY: clean
