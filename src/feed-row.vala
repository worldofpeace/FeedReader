/* -*- Mode: vala; indent-tabs-mode: t; c-basic-offset: 4; tab-width: 4 -*-  */
/*
 * feed-row.vala
 * Copyright (C) 2014 JeanLuc <jeanluc@jeanluc-desktop>
 *
 * tt-rss is free software: you can redistribute it and/or modify it
 * under the terms of the GNU General Public License as published by the
 * Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * tt-rss is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
 * See the GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License along
 * with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

public class FeedRow : baseRow {

	private bool m_subscribed;
	private int m_catID;
	private int m_level;
	public string m_name { get; private set; }
	public int m_ID { get; private set; }
	

	public FeedRow (string text, string unread_count, bool has_icon, string iconname, int catID, int level)
	{
		this.get_style_context().add_class("feed-list-row");
		m_level = level;
		m_catID = catID;
		m_subscribed = true;
		m_name = text.replace("&","&amp;");
		if(text != "")
		{
			m_ID = int.parse(iconname);
			var rowhight = 30;
			m_box = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 0);
			string icon_path = GLib.Environment.get_home_dir() + "/.local/share/feedreader/data/feed_icons/";

			if(has_icon)
			{
				try{
					Gdk.Pixbuf tmp_icon = new Gdk.Pixbuf.from_file(icon_path + iconname + ".ico");
					scale_pixbuf(ref tmp_icon, 24);
					m_icon = new Gtk.Image.from_pixbuf(tmp_icon);
				}catch(GLib.Error e){}
			}
			else
			{
				m_icon = new Gtk.Image.from_file("/usr/share/RSSReader/rss24.png");
			}

			m_revealer = new Gtk.Revealer();
			m_revealer.set_transition_type(Gtk.RevealerTransitionType.SLIDE_DOWN);
			m_revealer.set_transition_duration(500);
		
			m_unread_count = unread_count;
			m_label = new Gtk.Label(m_name);
			m_label.set_use_markup (true);
			m_label.set_size_request (0, rowhight);
			m_label.set_ellipsize (Pango.EllipsizeMode.END);
			m_label.set_alignment(0, 0.5f);
			
			m_unread = new Gtk.Label(null);
			set_unread_count(unread_count);
			m_unread.set_use_markup (true);
			m_unread.set_size_request (0, rowhight);
			m_unread.set_alignment(0.8f, 0.5f);
		
			m_spacer = new Gtk.Label("");
			m_spacer.set_size_request(level * 24, rowhight);

			if(m_catID != -1)
			{
				m_box.get_style_context().add_class("feed-row");
				m_box.pack_start(m_spacer, false, false, 0);
			}
			m_box.pack_start(m_icon, false, false, 8);
			m_box.pack_start(m_label, true, true, 0);
			m_box.pack_end (m_unread, false, false, 8);
			m_revealer.add(m_box);
			m_revealer.set_reveal_child(false);
			m_isRevealed = false;
			this.add(m_revealer);
			this.show_all();
		}
	}

	public void update(string text, string unread_count)
	{
		m_label.set_text(text.replace("&","&amp;"));
		m_label.set_use_markup (true);
		set_unread_count(unread_count);
	}

	public void setSubscribed(bool subscribed)
	{
		m_subscribed = subscribed;
	}

	public int getCategorie()
	{
		return m_catID;
	}

	public bool isSubscribed()
	{
		return m_subscribed;
	}

}

