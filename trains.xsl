
cat > /mnt/user-data/outputs/trains.xsl << 'XSLEOF'
<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output method="html" encoding="UTF-8" indent="yes"/>

  <xsl:template match="/">
    <html lang="en">
      <head>
        <meta charset="UTF-8"/>
        <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
        <title>Railway Trip Management</title>
        <style>
          * { margin: 0; padding: 0; box-sizing: border-box; }
          body {
            font-family: 'Segoe UI', Tahoma, sans-serif;
            background: #0a0a1a;
            color: #dde0f5;
            min-height: 100vh;
            padding: 36px 24px;
          }
          .header { text-align: center; margin-bottom: 36px; }
          .header h1 {
            font-size: 1.9rem;
            color: #b06ef3;
            letter-spacing: 2px;
            text-transform: uppercase;
            text-shadow: 0 0 18px rgba(176,110,243,.55);
          }
          .header p { margin-top: 7px; color: #666; font-size: .85rem; letter-spacing: 1px; }
          .table-wrapper {
            max-width: 1200px; margin: 0 auto;
            border-radius: 12px; overflow: hidden;
            border: 1px solid rgba(176,110,243,.28);
            box-shadow: 0 0 40px rgba(176,110,243,.15);
          }
          table { width: 100%; border-collapse: collapse; }
          thead tr { background: linear-gradient(135deg, #1a0933, #261457); }
          thead th {
            padding: 14px 16px; text-align: left;
            font-size: .74rem; text-transform: uppercase;
            letter-spacing: 1.4px; color: #c084fc;
            border-bottom: 2px solid rgba(176,110,243,.35);
          }
          tbody tr { background: #0f0f26; transition: background .15s; }
          tbody tr:nth-child(even) { background: #111130; }
          tbody tr:hover { background: #181840; }
          tbody td {
            padding: 12px 16px; font-size: .88rem;
            color: #cdd0f0; border-bottom: 1px solid rgba(255,255,255,.04);
            vertical-align: middle;
          }
          .badge {
            display: inline-block; padding: 3px 10px;
            border-radius: 20px; font-size: .74rem;
            font-weight: 600; letter-spacing: .4px;
          }
          .line-badge { background: rgba(176,110,243,.15); border: 1px solid rgba(176,110,243,.45); color: #c084fc; }
          .trip-badge { background: rgba(99,102,241,.15); border: 1px solid rgba(99,102,241,.45); color: #a5b4fc; }
          .type-Normal  { background: rgba(107,114,128,.2); color:#9ca3af; border:1px solid rgba(107,114,128,.4); }
          .type-Rapid   { background: rgba(59,130,246,.2);  color:#60a5fa; border:1px solid rgba(59,130,246,.4); }
          .type-Express { background: rgba(16,185,129,.2);  color:#34d399; border:1px solid rgba(16,185,129,.4); }
          .type-Coradia { background: rgba(245,158,11,.2);  color:#fbbf24; border:1px solid rgba(245,158,11,.4); }
          .price-eco { color:#a78bfa; font-weight:700; }
          .price-vip { color:#fbbf24; font-weight:700; }
          .lbl { font-size:.7rem; opacity:.6; margin-right:2px; }
          .days { font-size:.78rem; color:#8888bb; }
          .arrow { color:#444466; margin:0 4px; }
          .footer { text-align:center; margin-top:26px; color:#333355; font-size:.75rem; }
        </style>
      </head>
      <body>

        <div class="header">
          <h1>&#x1F686; Railway Trip Management</h1>
          <p>XSLT Part 1 &#8212; Trip Table &#8212; transport.xml</p>
        </div>

        <div class="table-wrapper">
          <table>
            <thead>
              <tr>
                <th>Line</th>
                <th>Trip Code</th>
                <th>Departure</th>
                <th>Arrival</th>
                <th>Train Type</th>
                <th>Schedule</th>
                <th>Economy Price</th>
                <th>VIP Price</th>
                <th>Days</th>
              </tr>
            </thead>
            <tbody>

              <!-- ═══════════════════════════════════════════════════
                   xsl:for-each  →  outer loop over each <line>
                   XPath: transport/lines/line
                   ═══════════════════════════════════════════════════ -->
              <xsl:for-each select="transport/lines/line">

                <!-- Store line-level values in variables -->
                <xsl:variable name="lineCode" select="@code"/>
                <xsl:variable name="deptId"   select="@departure"/>
                <xsl:variable name="arrvId"   select="@arrival"/>

                <!-- Resolve station names from the <stations> lookup list -->
                <xsl:variable name="deptName"
                  select="/transport/stations/station[@id=$deptId]/@name"/>
                <xsl:variable name="arrvName"
                  select="/transport/stations/station[@id=$arrvId]/@name"/>

                <!-- ═══════════════════════════════════════════════
                     xsl:for-each  →  inner loop over each <trip>
                     XPath (relative): trips/trip
                     One <tr> per trip.
                     ═══════════════════════════════════════════════ -->
                <xsl:for-each select="trips/trip">
                  <tr>

                    <!-- Line code -->
                    <td><span class="badge line-badge"><xsl:value-of select="$lineCode"/></span></td>

                    <!-- Trip code  (xsl:value-of extracts the @code attribute text) -->
                    <td><span class="badge trip-badge"><xsl:value-of select="@code"/></span></td>

                    <!-- Departure station name -->
                    <td><xsl:value-of select="$deptName"/></td>

                    <!-- Arrival station name -->
                    <td><xsl:value-of select="$arrvName"/></td>

                    <!-- Train type with colour-coded badge (xsl:choose = if/else) -->
                    <td>
                      <xsl:choose>
                        <xsl:when test="@type='Rapid'">
                          <span class="badge type-Rapid"><xsl:value-of select="@type"/></span>
                        </xsl:when>
                        <xsl:when test="@type='Express'">
                          <span class="badge type-Express"><xsl:value-of select="@type"/></span>
                        </xsl:when>
                        <xsl:when test="@type='Coradia'">
                          <span class="badge type-Coradia"><xsl:value-of select="@type"/></span>
                        </xsl:when>
                        <xsl:otherwise>
                          <span class="badge type-Normal"><xsl:value-of select="@type"/></span>
                        </xsl:otherwise>
                      </xsl:choose>
                    </td>

                    <!-- Schedule: departure time → arrival time -->
                    <!-- <schedule> is self-closing, so we access its attributes -->
                    <td>
                      <xsl:value-of select="schedule/@departure"/>
                      <span class="arrow">&#x2192;</span>
                      <xsl:value-of select="schedule/@arrival"/>
                    </td>

                    <!-- Economy price  (selects the <class> with @type='Economy') -->
                    <td>
                      <span class="lbl">DA</span>
                      <span class="price-eco">
                        <xsl:value-of select="class[@type='Economy']/@price"/>
                      </span>
                    </td>

                    <!-- VIP price (optional — not every trip has one) -->
                    <td>
                      <xsl:choose>
                        <xsl:when test="class[@type='VIP']">
                          <span class="lbl">DA</span>
                          <span class="price-vip">
                            <xsl:value-of select="class[@type='VIP']/@price"/>
                          </span>
                        </xsl:when>
                        <xsl:otherwise>
                          <span style="color:#333355">&#8212;</span>
                        </xsl:otherwise>
                      </xsl:choose>
                    </td>

                    <!-- Operating days -->
                    <td>
                      <span class="days"><xsl:value-of select="days"/></span>
                    </td>

                  </tr>
                </xsl:for-each>
                <!-- end inner loop (trips) -->

              </xsl:for-each>
              <!-- end outer loop (lines) -->

            </tbody>
          </table>
        </div>

        <div class="footer">
          <p>XSLT 1.0 Transformation &#8212; DSS Project Part 1 &#8212; Railway Trip Management</p>
        </div>

      </body>
    </html>
  </xsl:template>

</xsl:stylesheet>
XSLEOF
echo "Done. Lines: $(wc -l < /mnt/user-data/outputs/trains.xsl)"